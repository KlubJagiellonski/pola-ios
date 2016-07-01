import UIKit

class LoginViewController: UIViewController {
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
        
//        castView.delegate = self
    }
}
