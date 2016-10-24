import Foundation
import RxSwift
import RxCocoa
import Decodable
import FBSDKLoginKit

extension FBSDKLoginManager {
    var isLogged: Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
}

class UserManager {
    private static let skipStartScreenKey = "SkipStartScreen"
    private static let genderKey = "Gender"
    private static let defaultGender: Gender = .Female
    
    private let apiService: ApiService
    private let keychainManager: KeychainManager
    private let storage: KeyValueStorage
    private let disposeBag = DisposeBag()
    private let fbLoginManager = FBSDKLoginManager()
    private var cachedSharedWebCredential: SharedWebCredential?
    
    let userObservable = PublishSubject<User?>()
    let sessionObservable = PublishSubject<Session?>()
    let genderObservable = PublishSubject<Gender>()
    let authenticatedObservable = PublishSubject<Bool>()
    private var userSession: UserSession? {
        didSet {
            logInfo("Did set user session \(userSession)")
            
            if userSession == nil {
                PayUOptionHandler.resetUserCache()
            }
            
            Analytics.sharedInstance.user = user
            keychainManager.session = userSession?.session
            
            if !storage.save(userSession?.user, forKey: Constants.Persistent.currentUser, type: .PlatformPersistent) {
                logError("Could not save user \(userSession?.user)")
            }
            userObservable.onNext(userSession?.user)
            sessionObservable.onNext(userSession?.session)
            if userSession == nil && oldValue != nil {
                authenticatedObservable.onNext(false)
            } else if userSession != nil && oldValue == nil {
                authenticatedObservable.onNext(true)
            }
        }
    }
    var user: User? { return userSession?.user }
    var session: Session? { return userSession?.session }
    var gender: Gender {
        get {
            guard let genderString: String = storage.load(forKey: UserManager.genderKey),
                let loadedGender = Gender(rawValue: genderString) else {
                    self.gender = UserManager.defaultGender
                    return UserManager.defaultGender
            }
            return loadedGender
        }
        set {
            logInfo("Changed gender to \(newValue.rawValue)")
            storage.save(newValue.rawValue, forKey: UserManager.genderKey)
            genderObservable.onNext(newValue)
        }
    }
    var shouldSkipStartScreen: Bool {
        get {
            return storage.load(forKey: UserManager.skipStartScreenKey) ?? false
        }
        set {
            logInfo("Changed shouldSkipStartScreen to \(shouldSkipStartScreen)")
            storage.save(newValue, forKey: UserManager.skipStartScreenKey)
            shouldSkipStartScreenObservable.onNext(shouldSkipStartScreen)
        }
    }
    
    let shouldSkipStartScreenObservable = PublishSubject<Bool>()
    
    init(apiService: ApiService, keychainManager: KeychainManager, storage: KeyValueStorage, configurationManager: ConfigurationManager) {
        self.apiService = apiService
        self.keychainManager = keychainManager
        self.storage = storage
        
        apiService.dataSource = self
        
        let session = keychainManager.session
        let user: User? = storage.load(forKey: Constants.Persistent.currentUser, type: .PlatformPersistent)
        userSession = UserSession(user: user, session: session)
        
        configurationManager.configurationObservable.subscribeNext { [unowned self] configuration in
            if !configuration.availableGenders.contains(self.gender) {
                self.gender = configuration.availableGenders[0]
            }
        }.addDisposableTo(disposeBag)
    }
    
    func fetchSharedWebCredentials() -> Observable<SharedWebCredential> {
        logInfo("Fetching shared web credentials")
        return keychainManager.fetchSharedWebCredentials()
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] credential in self?.cachedSharedWebCredential = credential }
    }
    
    func login(with login: Login, updateSharedWebCredentials: Bool = true) -> Observable<SigningResult> {
        logInfo("Fetching login \(login)")
        return apiService.login(with: login)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                    if updateSharedWebCredentials {
                        self.updateSharedWebCredentialsIfNeeded(withUsername: login.username, password: login.password)
                    }
                    self.keychainManager.loginCredentials = login
                    logAnalyticsRegistration()
                }
        }
            .catchError { [weak self] error in
                logInfo("Received error when login \(error)")
                if let `self` = self {
                    self.userSession = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown(error))
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        logInfo("Validation error \(errorData)")
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    case 401:
                        // Invalid credentials
                        return Observable.error(SigningError.InvalidCredentials)
                    default:
                        return Observable.error(SigningError.Unknown(error))
                    }
                default:
                    return Observable.error(SigningError.Unknown(error))
                }
        }
    }
    
    func register(with registration: Registration) -> Observable<SigningResult> {
        logInfo("Registering \(registration)")
        return apiService.register(with: registration)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                    self.updateSharedWebCredentialsIfNeeded(withUsername: registration.username, password: registration.password)
                    self.keychainManager.loginCredentials = Login(username: registration.username, password: registration.password)
                    logAnalyticsRegistration()
                }
        }
            .catchError { [weak self] error in
                logInfo("Received error when registering \(error)")
                if let `self` = self {
                    self.userSession = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown(error))
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        logInfo("Validation error \(errorData)")
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    default:
                        return Observable.error(SigningError.Unknown(error))
                    }
                default:
                    return Observable.error(SigningError.Unknown(error))
                }
        }
    }
    
    func loginToFacebook(with viewController: UIViewController) -> Observable<SigningResult> {
        return Observable.create {
            [unowned self] observer in
            
            logInfo("Login with facebook")
            
            self.fbLoginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: viewController) {
                [weak self] (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
                guard let `self` = self else {
                    observer.onCompleted()
                    return
                }
                if error != nil {
                    logInfo("Facebook login error \(error)")
                    observer.onError(SigningError.FacebookError(error))
                    observer.onCompleted()
                } else if result.isCancelled {
                    logInfo("Facebook login cancelled")
                    observer.onError(SigningError.FacebookCancelled)
                    observer.onCompleted()
                } else {
                    logInfo("Facebook logged in to sdk")
                    self.loginWithFacebookToken(result.token.tokenString).subscribe(observer).addDisposableTo(self.disposeBag)
                }
            }
            return NopDisposable.instance
        }
    }
    
    func updateUser() {
        logInfo("Updating user")
        guard session != nil else {
            logInfo("No session")
            return
        }
        self.apiService.fetchUser()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (event: Event<User>) in
                guard let `self` = self else { return }
                
                switch event {
                case .Next(let user):
                    guard user != self.user else {
                        logInfo("Fetched user is the same")
                        return
                    }
                    logInfo("Updated user with info: \(user)")
                    self.userSession = UserSession(user: user, session: self.session)
                case .Error(let error):
                    logInfo("Could not update user with error: \(error)")
                default: break
                }
        }.addDisposableTo(disposeBag)
    }
    
    func logout() {
        logInfo("Logout")
        apiService.logout().subscribe().addDisposableTo(disposeBag)
        fbLoginManager.logOut()
        self.userSession = nil
        keychainManager.facebookToken = nil
        keychainManager.loginCredentials = nil
    }
    
    private func loginWithFacebookToken(token: String) -> Observable<SigningResult> {
        logInfo("Login with facebook token")
        return self.apiService.loginWithFacebook(with: FacebookLogin(accessToken: token))
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                logInfo("Facebook logged in to api")
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                    self.keychainManager.facebookToken = token
                    logAnalyticsRegistration()
                }
            }
            .catchError { [weak self] error in
                logInfo("Facebook failed to log in to api \(error)")
                if let `self` = self {
                    self.userSession = nil
                    self.keychainManager.facebookToken = nil
                    self.fbLoginManager.logOut()
                }
                
                return Observable.error(SigningError.Unknown(error))
        }
    }
    
    private func updateSharedWebCredentialsIfNeeded(withUsername username: String, password: String) {
        logInfo("Updating shared web credentials if needed \(username)")
        let newCredentials = SharedWebCredential(account: username, password: password)
        if cachedSharedWebCredential != newCredentials {
            logInfo("Credentials changed")
            self.keychainManager.addSharedWebCredentials(newCredentials).subscribe().addDisposableTo(self.disposeBag)
        }
    }
}

extension UserManager: ApiServiceDataSource {
    func apiServiceWantsSession(api: ApiService) -> Session? {
        return session
    }
    
    func apiServiceWantsHandleLoginRetry(api: ApiService) -> Observable<Void> {
        logInfo("Handle login retry")
        if let facebookToken = keychainManager.facebookToken {
            logInfo("Facebook token exist")
            return loginWithFacebookToken(facebookToken).flatMap({ _ in return Observable.just() })
        } else if let loginCredentials = keychainManager.loginCredentials {
            logInfo("Login credentials exist")
            return login(with: loginCredentials, updateSharedWebCredentials: false).flatMap({ _ in return Observable.just() })
        } else {
            return Observable.error(ApiError.LoginRetryFailed)
        }
    }
}
