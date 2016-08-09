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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Register)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    private func handleRegistrationResult(event: Event<SigningResult>) {
        castView.switcherState = .Success
        switch event {
        case .Next(let result):
            logInfo("Registered as \(result.user.name) (\(result.user.email))")
            sendNavigationEvent(SimpleNavigationEvent(type: .Close))
            toastManager.showMessage(tr(L10n.CommonGreeting(result.user.name)))
            userManager.gender = castView.gender
        case .Error(let error):
            logError("Error during registration: \(error)")
            switch error {
            case SigningError.FacebookCancelled: break
            case SigningError.ValidationFailed(let fieldsErrors):
                if let nameError = fieldsErrors.name {
                    castView.emailField.validation = nameError
                }
                if let emailError = fieldsErrors.email {
                    castView.emailField.validation = emailError
                }
                if let passwordError = fieldsErrors.password {
                    castView.passwordField.validation = passwordError
                }
                if let newsletterError = fieldsErrors.newsletter {
                    toastManager.showMessage(newsletterError)
                }
                break
            case SigningError.FacebookError(_), SigningError.Unknown:
                fallthrough
            default:
                toastManager.showMessage(tr(L10n.RegistrationErrorUnknown))
                break
            }
        default: break
        }
    }
    
    // MARK: - RegistrationViewDelegate
    
    func registrationViewDidTapFacebook() {
        castView.switcherState = .ModalLoading
        
        userManager.loginToFacebook(with: self)
            .subscribe { [weak self] event in self?.handleRegistrationResult(event) }
            .addDisposableTo(disposeBag)
    }
    
    func registrationViewDidTapRules() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowRules))
    }
    
    func registrationViewDidTapCreate() {
        guard castView.validate(showResult: true),
            let name = castView.name,
            let email = castView.email,
            let password = castView.password else {
                return
        }
        
        castView.switcherState = .ModalLoading
        
        let registration = Registration(name: name, username: email, password: password, newsletter: castView.receiveNewsletter, gender: castView.gender.rawValue)
        userManager.register(with: registration)
            .subscribe { [weak self] (event: Event<SigningResult>) in self?.handleRegistrationResult(event) }
            .addDisposableTo(disposeBag)
    }
    
    func registrationViewDidTapHaveAccount() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowLogin))
    }
    
    func registrationView(view: RegistrationView, wantShowMessage message: String) {
        toastManager.showMessage(message)
    }
}
