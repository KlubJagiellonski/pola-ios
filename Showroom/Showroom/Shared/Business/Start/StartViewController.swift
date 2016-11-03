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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Start)
    }
    
    private func didSelect(gender gender: Gender) {
        userManager.gender = gender
        logAnalyticsEvent(AnalyticsEventId.OnboardingGenderChoice(gender.rawValue))
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
    
    // MARK: - StartViewDelegate
    
    func startViewDidTapLogin() {
        logInfo("Tap login")
        logAnalyticsEvent(AnalyticsEventId.OnboardingLoginClicked)
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func startViewDidTapRegister() {
        logInfo("Tap register")
        logAnalyticsEvent(AnalyticsEventId.OnboardingRegisterClicked)
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Register)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func startViewDidTapForHer() {
        logInfo("Tap for her")
        didSelect(gender: .Female)
    }
    
    func startViewDidTapForHim() {
        logInfo("Tap for him")
        didSelect(gender: .Male)
    }
}

extension StartViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController, animated: Bool) {
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        guard let user = userManager.user else {
            logError("No user after login/register. Something is wrong. \(userManager.session)")
            return
        }
        userManager.gender = user.gender
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowDashboard))
    }
}
