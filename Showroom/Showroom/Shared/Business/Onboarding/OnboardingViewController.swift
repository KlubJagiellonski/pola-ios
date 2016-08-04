import UIKit

class OnboardingViewController: UIViewController, OnboardingViewDelegate {
    private let userManager: UserManager
    private let notificationsManager: NotificationsManager
    private let resolver: DiResolver
    
    private var castView: OnboardingView { return view as! OnboardingView }
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        self.notificationsManager = resolver.resolve(NotificationsManager.self)
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Onboarding)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didHideRegisterAlert() {
        sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
    }
    
    // MARK:- OnboardingViewDelegate
    
    func onboardingDidTapSkip(view: OnboardingView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
    }
    
    func onboardingDidTapAskForNotification(view: OnboardingView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OnboardingViewController.didHideRegisterAlert), name: UIApplicationDidBecomeActiveNotification, object: nil)
        if !notificationsManager.registerForRemoteNotificationsIfNeeded() {
            sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
        }
    }
}