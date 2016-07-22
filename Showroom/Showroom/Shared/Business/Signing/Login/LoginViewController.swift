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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    // MARK: - LoginViewDelegate
    
    func loginViewDidTapFacebook() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil {
                logInfo("Login error")
            } else if result.isCancelled {
                logInfo("Login canceled")
            } else {
                logInfo("Logged in")
            }
        }
    }
    
    func loginViewDidTapLogin() {
        guard castView.validate(showResult: true), let email = castView.email, let password = castView.password else {
            return
        }
        
        castView.switcherState = .ModalLoading
        
        userManager.login(withEmail: email, password: password)
            .subscribe { [weak self](event: Event<SigningResult>) in
                guard let strongSelf = self else { return }
                
                strongSelf.castView.switcherState = .Success
                switch event {
                case .Next(let result):
                    logInfo("Logged in as \(result.user.name) (\(result.user.email))")
                    strongSelf.sendNavigationEvent(SimpleNavigationEvent(type: .Close))
                    strongSelf.toastManager.showMessage(tr(L10n.CommonGreeting(result.user.name)))
                case .Error(let error):
                    logError("Error during login: \(error)")
                    switch error {
                    case SigningError.ValidationFailed(let fieldsErrors):
                        if let usernameError = fieldsErrors.username {
                            strongSelf.castView.emailField.validation = usernameError
                        }
                        if let passwordError = fieldsErrors.password {
                            strongSelf.castView.passwordField.validation = passwordError
                        }
                        break
                    case SigningError.InvalidCredentials:
                        strongSelf.toastManager.showMessage(tr(L10n.LoginErrorInvalidCredentials))
                        break
                    case SigningError.Unknown:
                        fallthrough
                    default:
                        strongSelf.toastManager.showMessage(tr(L10n.LoginErrorUnknown))
                        break
                    }
                default: break
                }
        }.addDisposableTo(disposeBag)
    }
    
    func loginViewDidTapRemindPassword() {
        
    }
    
    func loginViewDidTapRegister() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowRegistration))
    }
}
