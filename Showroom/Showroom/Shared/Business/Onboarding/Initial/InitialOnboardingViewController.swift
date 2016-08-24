import UIKit

class InitialOnboardingViewController: UIViewController, InitialOnboardingViewDelegate {
    private let userManager: UserManager
    private let notificationsManager: NotificationsManager
    private let resolver: DiResolver
    
    private var castView: InitialOnboardingView { return view as! InitialOnboardingView }
    
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
        view = InitialOnboardingView()
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
        logInfo("Did hide register alert")
        if notificationsManager.isRegistered {
            logAnalyticsEvent(.OnboardingNotificationAllow)
        } else {
            logAnalyticsEvent(.OnboardingNotificationDisallow)
        }
        sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
    }
    
    // MARK:- OnboardingViewDelegate
    
    func onboardingDidTapSkip(view: InitialOnboardingView) {
        logInfo("Onboarding did tap skip notifications")
        logAnalyticsEvent(.OnboardingNotificationSkip)
        sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
    }
    
    func onboardingDidTapAskForNotification(view: InitialOnboardingView) {
        logInfo("Onboarding did tap ask for notifications")
        logAnalyticsEvent(.OnboardingNotificationClicked)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InitialOnboardingViewController.didHideRegisterAlert), name: UIApplicationDidBecomeActiveNotification, object: nil)
        if !notificationsManager.registerForRemoteNotificationsIfNeeded() {
            sendNavigationEvent(SimpleNavigationEvent(type: .OnboardingEnd))
        }
    }
}