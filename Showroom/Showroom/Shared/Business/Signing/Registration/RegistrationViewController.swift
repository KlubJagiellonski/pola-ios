import UIKit
import RxSwift

class RegistrationViewController: UIViewController, RegistrationViewDelegate {
    private let resolver: DiResolver
    private let userManager: UserManager
    private let toastManager: ToastManager
    private var castView: RegistrationView { return view as! RegistrationView }
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
        view = RegistrationView()
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
    
    // MARK: - RegistrationViewDelegate
    
    func registrationViewDidTapFacebook() {
        
    }
    
    func registrationViewDidTapRules() {
        
    }
    
    func registrationViewDidTapCreate() {
        guard castView.validate(showResult: true),
            let name = castView.name,
            let email = castView.email,
            let password = castView.password else {
                return
        }
        
        castView.switcherState = .ModalLoading
        
        userManager.register(withName: name, email: email, password: password, receiveNewsletter: castView.receiveNewsletter)
            .subscribe { [weak self](event: Event<SigningResult>) in
                guard let strongSelf = self else { return }
                
                strongSelf.castView.switcherState = .Success
                switch event {
                case .Next(let result):
                    logInfo("Registered as \(result.user.name) (\(result.user.email))")
                    strongSelf.sendNavigationEvent(SimpleNavigationEvent(type: .Close))
                    strongSelf.toastManager.showMessage(tr(L10n.CommonGreeting(result.user.name)))
                case .Error(let error):
                    logError("Error during registration: \(error)")
                    switch error {
                    case SigningError.ValidationFailed(let fieldsErrors):
                        if let nameError = fieldsErrors.name {
                            strongSelf.castView.emailField.validation = nameError
                        }
                        if let emailError = fieldsErrors.email {
                            strongSelf.castView.emailField.validation = emailError
                        }
                        if let passwordError = fieldsErrors.password {
                            strongSelf.castView.passwordField.validation = passwordError
                        }
                        if let newsletterError = fieldsErrors.newsletter {
                            strongSelf.toastManager.showMessage(newsletterError)
                        }
                        break
                    case SigningError.Unknown:
                        fallthrough
                    default:
                        strongSelf.toastManager.showMessage(tr(L10n.RegistrationErrorUnknown))
                        break
                    }
                default: break
                }
        }.addDisposableTo(disposeBag)
    }
    
    func registrationViewDidTapHaveAccount() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowLogin))
    }
    
    func registrationView(view: RegistrationView, wantShowMessage message: String) {
        toastManager.showMessage(message)
    }
}
