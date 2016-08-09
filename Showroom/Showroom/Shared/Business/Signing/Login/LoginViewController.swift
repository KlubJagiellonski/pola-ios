import UIKit
import RxSwift
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, LoginViewDelegate {
    private let resolver: DiResolver
    private let userManager: UserManager
    private let toastManager: ToastManager
    private var castView: LoginView { return view as! LoginView }
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        self.toastManager = resolver.resolve(ToastManager.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        userManager.fetchSharedWebCredentials().subscribeNext { [weak self] credential in
            self?.castView.email = credential.account
            self?.castView.password = credential.password
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Login)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    private func handleLoginResult(event: Event<SigningResult>) {
        castView.switcherState = .Success
        switch event {
        case .Next(let result):
            logInfo("Logged in as \(result.user.name) (\(result.user.email))")
            sendNavigationEvent(SimpleNavigationEvent(type: .Close))
            toastManager.showMessage(tr(L10n.CommonGreeting(result.user.name)))
        case .Error(let error):
            logError("Error during login: \(error)")
            switch error {
            case SigningError.FacebookCancelled: break
            case SigningError.ValidationFailed(let fieldsErrors):
                if let usernameError = fieldsErrors.username {
                    castView.emailField.validation = usernameError
                }
                if let passwordError = fieldsErrors.password {
                    castView.passwordField.validation = passwordError
                }
                break
            case SigningError.InvalidCredentials:
                toastManager.showMessage(tr(L10n.LoginErrorInvalidCredentials))
                break
            case SigningError.FacebookError(_), SigningError.Unknown:
                fallthrough
            default:
                toastManager.showMessage(tr(L10n.LoginErrorUnknown))
                break
            }
        default: break
        }
    }
    
    // MARK: - LoginViewDelegate
    
    func loginViewDidTapFacebook() {
        logAnalyticsEvent(AnalyticsEventId.LoginFacebookClicked)
        
        castView.switcherState = .ModalLoading
        
        userManager.loginToFacebook(with: self)
            .subscribe { [weak self] event in self?.handleLoginResult(event) }
            .addDisposableTo(disposeBag)
    }
    
    func loginViewDidTapLogin() {
        guard castView.validate(showResult: true), let email = castView.email, let password = castView.password else {
            return
        }
        
        logAnalyticsEvent(AnalyticsEventId.LoginClicked)
        
        castView.switcherState = .ModalLoading
        
        userManager
            .login(with: Login(username: email, password: password))
            .subscribe { [weak self] event in self?.handleLoginResult(event) }
            .addDisposableTo(disposeBag)
    }
    
    func loginViewDidTapRemindPassword() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowResetPassword))
    }
    
    func loginViewDidTapRegister() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowRegistration))
    }
}