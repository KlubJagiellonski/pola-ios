import UIKit

class OnboardingViewController: UIViewController, OnboardingViewDelegate {
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
        super.viewDidLoad()
        
        castView.delegate = self
        // TODO: remove after testing
        userManager.shouldSkipStartScreen = true
    }
    
    // MARK:- OnboardingViewDelegate
    
    func onboardingDidTapSkip(view: OnboardingView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
    }
    
    func onboardingDidTapAskForNotification(view: OnboardingView) {
        //todo ask for notification
    }
}