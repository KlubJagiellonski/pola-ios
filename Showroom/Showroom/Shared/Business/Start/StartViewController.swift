import UIKit

class StartViewController: UIViewController, StartViewDelegate {
    private let resolver: DiResolver
    private let userManager: UserManager
    private var castView: StartView { return view as! StartView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = StartView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        userManager.shouldSkipStartScreen = true
    }
    
    // MARK: - StartViewDelegate
    
    func startViewDidTapLogin() {
        logInfo("Tap login")
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func startViewDidTapRegister() {
        logInfo("Tap register")
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Register)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func startViewDidTapForHer() {
        logInfo("Tap for her")
        userManager.gender = .Female
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    
    func startViewDidTapForHim() {
        logInfo("Tap for him")
        userManager.gender = .Male
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
}

extension StartViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
