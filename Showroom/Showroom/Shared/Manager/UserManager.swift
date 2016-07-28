import Foundation
import RxSwift
import RxCocoa
import Decodable
import FBSDKLoginKit

extension KeychainManager {
    private var userIdIdentifier: String { return "showroom_token_user_id" }
    private var userSecret: String { return "showroom_token_user_secret" }
    
    private func saveSession(session: Session?) {
        setPasscode(userIdIdentifier, passcode: session?.userKey)
        setPasscode(userSecret, passcode: session?.userSecret)
    }
    
    private func loadSession() -> Session? {
        if let userId = getPasscode(userIdIdentifier), let userSecret = getPasscode(userSecret) {
            return Session(userKey: userId, userSecret: userSecret)
        }
        return nil
    }
}

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
    private let emarsysService: EmarsysService
    private let keychainManager: KeychainManager
    private let storageManager: StorageManager
    private let disposeBag = DisposeBag()
    private let fbLoginManager = FBSDKLoginManager()
    private var cachedSharedWebCredential: SharedWebCredential?
    
    let userObservable = PublishSubject<User?>()
    let sessionObservable = PublishSubject<Session?>()
    let genderObservable = PublishSubject<Gender>()
    private var userSession: UserSession? {
        didSet {
            emarsysService.configureUser(String(userSession?.user.id), customerEmail: userSession?.user.email)
            keychainManager.saveSession(userSession?.session)
            do {
                try storageManager.save(Constants.Persistent.currentUser, object: userSession?.user)
            } catch {
                logError("Could not save user \(userSession?.user) with error \(error)")
            }
            userObservable.onNext(userSession?.user)
            sessionObservable.onNext(userSession?.session)
        }
    }
    var user: User? { return userSession?.user }
    var session: Session? { return userSession?.session }
    var gender: Gender {
        get {
            guard let genderString = NSUserDefaults.standardUserDefaults().stringForKey(UserManager.genderKey),
                let loadedGender = Gender(rawValue: genderString) else {
                    self.gender = UserManager.defaultGender
                    return UserManager.defaultGender
            }
            return loadedGender
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue.rawValue, forKey: UserManager.genderKey)
            genderObservable.onNext(newValue)
            logInfo("Changed gender to \(newValue.rawValue)")
        }
    }
    var shouldSkipStartScreen: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(UserManager.skipStartScreenKey);
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserManager.skipStartScreenKey);
        }
    }
    
    init(apiService: ApiService, emarsysService: EmarsysService, keychainManager: KeychainManager, storageManager: StorageManager) {
        self.apiService = apiService
        self.emarsysService = emarsysService
        self.keychainManager = keychainManager
        self.storageManager = storageManager
        
        let session = keychainManager.loadSession()
        var user: User?
        do {
            user = try storageManager.load(Constants.Persistent.currentUser)
        } catch {
            logError("Error while loading current user from cache \(error)")
        }
        userSession = UserSession(user: user, session: session)
    }
    
    func fetchSharedWebCredentials() -> Observable<SharedWebCredential> {
        return keychainManager.fetchSharedWebCredentials()
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] credential in self?.cachedSharedWebCredential = credential }
    }
    
    func login(with login: Login) -> Observable<SigningResult> {
        return apiService.login(with: login)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                    self.updateSharedWebCredentialsIfNeeded(withUsername: login.username, password: login.password)
                }
        }
            .catchError { [weak self] error in
                if let `self` = self {
                    self.userSession = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown)
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        logInfo(validtionError.message)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    case 401:
                        // Invalid credentials
                        return Observable.error(SigningError.InvalidCredentials)
                    default:
                        return Observable.error(SigningError.Unknown)
                    }
                default:
                    return Observable.error(SigningError.Unknown)
                }
        }
    }
    
    func register(with registration: Registration) -> Observable<SigningResult> {
        return apiService.register(with: registration)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                    self.updateSharedWebCredentialsIfNeeded(withUsername: registration.username, password: registration.password)
                }
        }
            .catchError { [weak self] error in
                if let `self` = self {
                    self.userSession = nil
                }
                
                guard let urlError = error as? RxCocoaURLError else {
                    return Observable.error(SigningError.Unknown)
                }
                
                switch urlError {
                case .HTTPRequestFailed(let response, let data):
                    switch response.statusCode {
                    case 400:
                        // Validation Failed
                        let errorData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        logInfo("\(errorData)")
                        let validtionError: SigningValidationError = try SigningValidationError.decode(errorData)
                        logInfo(validtionError.message)
                        return Observable.error(SigningError.ValidationFailed(validtionError.errors))
                    default:
                        return Observable.error(SigningError.Unknown)
                    }
                default:
                    return Observable.error(SigningError.Unknown)
                }
        }
    }
    
    func loginToFacebook(with viewController: UIViewController) -> Observable<SigningResult> {
        return Observable.create {
            [unowned self] observer in
            
            logDebug("Login with facebook")
            
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
                    self.loginWithFacebookToken(result.token).subscribe(observer).addDisposableTo(self.disposeBag)
                }
            }
            return NopDisposable.instance
        }
    }
    
    private func loginWithFacebookToken(token: FBSDKAccessToken) -> Observable<SigningResult> {
        return self.apiService.loginWithFacebook(with: FacebookLogin(accessToken: token.tokenString))
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                logInfo("Facebook logged in to api")
                if let `self` = self {
                    self.userSession = UserSession(user: result.user, session: result.session)
                }
            }
            .catchError { [weak self] error in
                logInfo("Facebook failed to log in to api \(error)")
                if let `self` = self {
                    self.userSession = nil
                    self.fbLoginManager.logOut()
                }
                
                return Observable.error(SigningError.Unknown)
        }
    }
    
    private func updateSharedWebCredentialsIfNeeded(withUsername username: String, password: String) {
        let newCredentials = SharedWebCredential(account: username, password: password)
        if cachedSharedWebCredential != newCredentials {
            self.keychainManager.addSharedWebCredentials(newCredentials).subscribe().addDisposableTo(self.disposeBag)
        }
    }
    
    func logout() {
        apiService.logout().subscribe().addDisposableTo(disposeBag)
        fbLoginManager.logOut()
        self.userSession = nil
    }
}

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
}