import UIKit
import RxSwift

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
        
    }
    
    func loginViewDidTapLogin() {
        guard castView.validate(showResult: true), let email = castView.email, let password = castView.password else {
            return
        }
        
        castView.switcherState = .ModalLoading
        
        userManager.login(wiethEmail: email, password: password)
            .subscribe { [weak self](event: Event<LoginResult>) in
                guard let strongSelf = self else { return }
                
                strongSelf.castView.switcherState = .Success
                switch event {
                case .Next(let result):
                    logInfo("Logged in as \(result.user.name) (\(result.user.email))")
                    strongSelf.sendNavigationEvent(SimpleNavigationEvent(type: .Close))
                case .Error(let error):
                    logError("Error during login: \(error)")
                    switch error {
                    case LoginError.ValidationFailed(let fieldsErrors):
                        if let usernameError = fieldsErrors.username {
                            strongSelf.castView.emailField.validation = usernameError
                        }
                        if let passwordError = fieldsErrors.password {
                            strongSelf.castView.passwordField.validation = passwordError
                        }
                        break
                    case LoginError.InvalidCredentials:
                        strongSelf.toastManager.showMessage(tr(L10n.LoginErrorInvalidCredentials))
                        break
                    case LoginError.Unknown:
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
