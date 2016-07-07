import UIKit

class RegistrationViewController: UIViewController, RegistrationViewDelegate {
    private let resolver: DiResolver
    private let toastManager: ToastManager
    private var castView: RegistrationView { return view as! RegistrationView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
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
        castView.validate(showResult: true)
    }
    
    func registrationViewDidTapHaveAccount() {
        
    }
    
    func registrationView(view: RegistrationView, wantShowMessage message: String) {
        toastManager.showMessage(message)
    }
}
