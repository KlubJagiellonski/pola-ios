import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
    private let resolver: DiResolver
    private var castView: LoginView { return view as! LoginView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
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
        castView.validate(showResult: true)
        // TODO: Do something when it's valid
    }
    
    func loginViewDidTapRemindPassword() {
        
    }
    
    func loginViewDidTapRegister() {
        
    }
}
