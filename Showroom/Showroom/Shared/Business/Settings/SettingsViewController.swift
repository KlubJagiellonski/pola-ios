import Foundation
import UIKit
import RxSwift
import MessageUI

class SettingsViewController: UIViewController {
    private let userManager: UserManager
    private let notificationsManager: NotificationsManager
    private let platformManager: PlatformManager
    private let disposeBag = DisposeBag()
    private let toastManager: ToastManager
    private let versionManager: VersionManager
    private var castView: SettingsView { return view as! SettingsView }
    
    private var firstLayoutSubviewsPassed = false
    
    private lazy var onboardingActionAnimator: InAppOnboardingActionAnimator = { [unowned self] in
        return InAppOnboardingActionAnimator(parentViewHeight: self.castView.bounds.height)
    }()
    private lazy var formSheetAnimator: FormSheetAnimator = { [unowned self] in
        let animator = FormSheetAnimator()
        animator.delegate = self
        return animator
    }()
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        self.notificationsManager = resolver.resolve(NotificationsManager.self)
        self.toastManager = resolver.resolve(ToastManager.self)
        self.platformManager = resolver.resolve(PlatformManager.self)
        self.versionManager = resolver.resolve(VersionManager.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettings(with: userManager.user)
        
        self.userManager.userObservable.subscribeNext { [weak self] user in
            self?.updateSettings(with: user)
            }.addDisposableTo(disposeBag)
        self.userManager.genderObservable.subscribeNext { [weak self] gender in
            self?.updateGender(with: gender)
            }.addDisposableTo(disposeBag)
        self.notificationsManager.shouldShowInSettingsObservable.subscribeNext { [weak self] showInSettings in
            self?.updateSettings()
            }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Settings)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        markHandoffUrlActivity(withPathComponent: "/", resolver: resolver)
        castView.deselectRowsIfNeeded()
    }

    private func updateSettings(with user: User?) {
        logInfo("Updating settings with user exist \(user != nil)")
        
        var settings = [
            Setting(type: .Header, action: { [weak self] in self?.facebookButtonPressed() }, secondaryAction: { [weak self] in self?.instagramButtonPressed() }, cellClickable: false),
            ]
        
        if let user = user {
            settings.append(Setting(type: .Logout, labelString: tr(.CommonGreeting(user.name)), action: { [weak self] in self?.logoutButtonPressed() }, cellClickable: false))
        } else {
            settings.append(Setting(type: .Login, action: { [weak self] in self?.loginButtonPressed() }, secondaryAction: { [weak self] in self?.createAccountButtonPressed() }, cellClickable: false))
        }
        
        if platformManager.platform?.isFemaleOnly == false ?? false {
            settings.append(Setting(type: .Gender, action: { [weak self] in self?.femaleButtonPressed() }, secondaryAction: { [weak self] in self?.maleButtonPressed() }, cellClickable: false, value: self.userManager.gender))
        }
                
        if notificationsManager.shouldShowInSettings {
            settings.append(
                Setting(type: .AskForNotification, action: { [weak self] in self?.askForNotificationPressed() }, cellClickable: false)
            )
        }
        
        if user != nil {
            settings.append(Setting(type: .Normal, labelString: tr(.SettingsUserData), action: { [weak self] in self?.userDataRowPressed() }))
            settings.append(Setting(type: .Normal, labelString: tr(.SettingsHistory), action: { [weak self] in self?.historyRowPressed() }))
        }
        
        settings.appendContentsOf([
            Setting(type: .Normal, labelString: tr(.SettingsSendReport), action: { [weak self] in self?.sendReportPressed() }),
            Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: { [weak self] in self?.frequentQuestionsRowPressed() }),
            Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: { [weak self] in self?.howToMeasureRowPressed() }),
            Setting(type: .Normal, labelString: tr(.SettingsContact), action: { [weak self] in self?.contactRowPressed() }),
            Setting(type: .Normal, labelString: tr(.SettingsRules), action: { [weak self] in self?.rulesRowPressed() }),
            Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: { [weak self] in self?.privacyPolicyRowPressed() }),
            Setting(type: .Platform, labelString: tr(.SettingsPlatform), secondaryLabelString: platformManager.platform?.platformString, action: { [weak self] in self?.platformRowPressed() })
            ])
        
        if !Constants.isAppStore {
            settings.append(Setting(type: .Normal, labelString: "Pokaż onboarding", action: { [weak self] in self?.showOnboarding() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż in-app wishlist onboarding", action: { [weak self] in self?.showInAppWishlistOnboarding() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż in-app paging onboarding", action: { [weak self] in self?.showInAppPagingOnboarding() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż oceń nas (po czasie)", action: { [weak self] in self?.showRateAppAfterTime() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż oceń nas (po zakupie)", action: { [weak self] in self?.showRateAppAfterBuy() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż pytanie o powiadomienia (po czasie)", action: { [weak self] in self?.showNotificationsAccessAfterTime() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż pytanie o powiadomienia (schowek)", action: { [weak self] in self?.showNotificationsAccessAfterWishlist() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż pytanie o aktualizację", action: { [weak self] in self?.showUpdateApp() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż initial platform selection", action: { [weak self] in self?.showInitialPlatformSelection() }))
            settings.append(Setting(type: .Normal, labelString: "Pokaż slideshow 1", action: { [weak self] in self?.showSlideshow() }))
        }
        
        castView.updateData(with: settings)
    }
    
    private func updateSettings() {
        updateSettings(with: userManager.user)
    }
    
    private func updateGender(with gender: Gender) {
        logInfo("Update gender \(gender)")
        castView.updateData(with: gender)
    }
    
    func facebookButtonPressed() {
        logInfo("facebookButtonPressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileSocialMediaClicked("fb"))
        tryOpenURL(urlOptions: ["fb://profile/159930354087746", "https://www.facebook.com/shwrm"])
    }
    
    func instagramButtonPressed() {
        logInfo("instagramButtonPressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileSocialMediaClicked("insta"))
        tryOpenURL(urlOptions: ["instagram://user?username=shwrm", "https://www.instagram.com/shwrm"])
    }
    
    func loginButtonPressed() {
        logInfo("loginButtonPressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileLoginClicked)
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func createAccountButtonPressed() {
        logInfo("createAccountButtonPressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileRegisterClicked)
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Register)
        viewController.signingDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func logoutButtonPressed() {
        logInfo("logoutButtonPressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileLogoutClicked)
        userManager.logout()
    }
    
    func femaleButtonPressed() {
        logInfo("femaleButtonPressed")
        didChange(gender: .Female)
    }
    
    func maleButtonPressed() {
        logInfo("maleButtonPressed")
        didChange(gender: .Male)
    }
    
    func platformRowPressed() {
        logInfo("platform selection row pressed")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowSettingsPlatformSelection))
    }
    
    func askForNotificationPressed() {
        logInfo("Ask for notification pressed")
        logAnalyticsEvent(AnalyticsEventId.ProfileNotifications)
        notificationsManager.registerForRemoteNotificationsIfNeeded()
        updateSettings(with: userManager.user)
    }
    
    func userDataRowPressed() {
        logInfo("userDataRowPressed")
        logAnalyticsShowScreen(.UserData)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("user_info"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsUserData), webType: .UserData))
    }

    func historyRowPressed() {
        logInfo("historyRowPressed")
        logAnalyticsShowScreen(.OrdersHistory)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("orders_history"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsHistory), webType: .History))
    }
    
    func howToMeasureRowPressed() {
        logInfo("howToMeasureRowPressed")
        logAnalyticsShowScreen(.HowToMeasure)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("how_to_measure"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsHowToMeasure), webType: .HowToMeasure))
    }
    
    func privacyPolicyRowPressed() {
        logInfo("privacyPolicyRowPressed")
        logAnalyticsShowScreen(.Policy)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("policy"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsPrivacyPolicy), webType: .PrivacyPolicy))
    }
    
    func frequentQuestionsRowPressed() {
        logInfo("frequentQuestionsRowPressed")
        logAnalyticsShowScreen(.FAQ)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("faq"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsFrequentQuestions), webType: .FrequestQuestions))
    }
    
    func rulesRowPressed() {
        logInfo("rulesRowPressed")
        logAnalyticsShowScreen(.Rules)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("rules"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsRules), webType: .Rules))
    }
    
    func contactRowPressed() {
        logInfo("contactRowPressed")
        logAnalyticsShowScreen(.Contact)
        logAnalyticsEvent(AnalyticsEventId.ProfileWebViewLinkClicked("contact"))
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsContact), webType: .Contact))
    }
    
    func showOnboarding() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowOnboarding))
    }
    
    func showInAppWishlistOnboarding() {
        let wishlistOnboardingViewController = WishlistInAppOnboardingViewController()
        wishlistOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(wishlistOnboardingViewController, presentingViewController: self)
    }
    
    func showInAppPagingOnboarding() {
        let pagingOnboardingViewController = PagingInAppOnboardingViewController()
        pagingOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(pagingOnboardingViewController, presentingViewController: self)
    }
    
    func showRateAppAfterTime() {
        showRateApp(withType: .AfterTime)
    }
    
    func showRateAppAfterBuy() {
        showRateApp(withType: .AfterBuy)
    }
    
    func showRateApp(withType type: RateAppViewType) {
        let viewController = self.resolver.resolve(RateAppViewController.self, argument: type)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
    }
    
    func showNotificationsAccessAfterTime() {
        showNotificationsAccess(.AfterTime)
    }
    
    func showNotificationsAccessAfterWishlist() {
        showNotificationsAccess(.AfterWishlist)
    }
    
    func showNotificationsAccess(type: NotificationsAccessViewType) {
        let viewController = self.resolver.resolve(NotificationsAccessViewController.self, argument: type)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
    }
    
    func showUpdateApp() {
        self.versionManager.fetchLatestVersion()
            .subscribeNext { [weak self](appVersion: AppVersion) in
                guard let `self` = self else { return }
                let viewController = self.resolver.resolve(UpdateAppViewController.self, argument: appVersion.promoImageUrl)
                viewController.delegate = self
                self.formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        }.addDisposableTo(self.disposeBag)
    }
    
    func showInitialPlatformSelection() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowInitialPlatformSelection))
    }
    
    func showSlideshow() {
        sendNavigationEvent(ShowPromoSlideshowEvent(slideshowId: 1))
    }
    
    func sendReportPressed() {
        logInfo("sendReportPressed")
        
        castView.deselectRowsIfNeeded()
        
        guard MFMailComposeViewController.canSendMail() else {
            toastManager.showMessage(tr(.SettingsSendReportMailNotConfigured))
            return
        }
        
        guard let reportEmail = platformManager.reportEmail else {
            logError("Cannot report email with platform \(platformManager.platform)")
            return
        }
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setSubject(tr(.SettingsSendReportTitle))
        viewController.setToRecipients([reportEmail])
        if let deviceInfo = generateReportDeviceInfo() {
            viewController.addAttachmentData(deviceInfo, mimeType: "text/plain", fileName: "report.txt")
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    private func didChange(gender gender: Gender) {
        logInfo("Did change gender \(gender)")
        logAnalyticsEvent(AnalyticsEventId.ProfileGenderChoice(gender.rawValue))
        userManager.gender = gender
    }
    
    private func generateReportDeviceInfo() -> NSData? {
        let device = UIDevice.currentDevice()
        
        var deviceInfo = ""
        deviceInfo += "platform: \(platformManager.platform)"
        deviceInfo += "systemInfo: \(device.systemName), \(device.systemVersion)\n"
        deviceInfo += "deviceInfo: \(device.name), \(device.model), \(device.screenType.rawValue), \(device.modelName)\n"
        deviceInfo += "appInfo: \(NSBundle.appVersionNumber), \(NSBundle.appBuildNumber)\n"
        deviceInfo += "preferredLanguages: \(NSLocale.preferredLanguages())\n"
        return deviceInfo.dataUsingEncoding(NSUTF8StringEncoding)
    }
}

extension SettingsViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController) {
        logInfo("Dismissed signing")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
        logInfo("Did logged in")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SettingsViewController: WishlistInAppOnboardingViewControllerDelegate {
    func wishlistOnboardingViewControllerDidTapDismissButton(viewController: WishlistInAppOnboardingViewController) {
        onboardingActionAnimator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension SettingsViewController: PagingInAppOnboardingViewControllerDelegate {
    func pagingOnboardingViewControllerDidTapDismiss(viewController: PagingInAppOnboardingViewController) {
        onboardingActionAnimator.dismissViewController(presentingViewController: self)
    }
}

extension SettingsViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        animator.dismissViewController(presentingViewController: self, animated: true, completion: nil)
    }
}

extension SettingsViewController: RateAppViewControllerDelegate {
    func rateAppWantsDismiss(viewController: RateAppViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension SettingsViewController: NotificationsAccessViewControllerDelegate {
    func notificationsAccessWantsDismiss(viewController: NotificationsAccessViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension SettingsViewController: UpdateAppViewControllerDelegate {
    func updateAppWantsDismiss(viewController: UpdateAppViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        logInfo("Did finish mail composing \(result)")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension Platform {
    private var platformString: String {
        switch self {
        case Polish: return "showroom.pl"
        case German: return "showroom.de"
        }
    }
}