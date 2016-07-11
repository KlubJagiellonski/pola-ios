import UIKit

class OnboardingViewController: UIViewController {
    private let userManager: UserManager
    private let resolver: DiResolver
    
    private var castView: OnboardingView { return view as! OnboardingView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = OnboardingView()
    }
    
    override func viewDidLoad() {
        // TODO: remove after testing
        userManager.shouldSkipStartScreen = true
    }
}