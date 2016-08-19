import Foundation
import UIKit
import RxSwift
import MessageUI

class SettingsViewController: UIViewController {
    private let userManager: UserManager
    private let notificationsManager: NotificationsManager
    private let disposeBag = DisposeBag()
    private let toastManager: ToastManager
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
        
        super.init(nibName: nil, bundle: nil)
        self.userManager.userObservable.subscribeNext(updateSettings).addDisposableTo(disposeBag)
        self.userManager.genderObservable.subscribeNext(updateGender).addDisposableTo(disposeBag)
        
        self.notificationsManager.shouldShowInSettingsObservable.subscribeNext(updateSettings).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSettings(with user: User?) {
        var settings = [
            Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed, cellClickable: false),
        ]
        if let user = user {
            settings.append(
                Setting(type: .Logout, labelString: tr(.CommonGreeting(user.name)), action: self.logoutButtonPressed, cellClickable: false)
            )
        } else {
            settings.append(
                Setting(type: .Login, action: self.loginButtonPressed, secondaryAction: self.createAccountButtonPressed, cellClickable: false)
            )
        }
        settings.append(
            Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed, cellClickable: false, value: self.userManager.gender)
        )
        if notificationsManager.shouldShowInSettings {
            settings.append(
                Setting(type: .AskForNotification, action: self.askForNotificationPressed, cellClickable: false)
            )
        }
        if user != nil {
            settings.append(Setting(type: .Normal, labelString: tr(.SettingsUserData), action: self.userDataRowPressed))
            settings.append(Setting(type: .Normal, labelString: tr(.SettingsHistory), action: self.historyRowPressed))
        }
        settings.appendContentsOf([
            Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
            Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
            Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
            Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
            Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed),
            Setting(type: .Normal, labelString: tr(.SettingsSendReport), action: self.sendReportPressed)
        ])
        if !Constants.isAppStore {
            settings.append(Setting(type: .Normal, labelString: "Pokaż onboarding", action: self.showOnboarding))
            settings.append(Setting(type: .Normal, labelString: "Pokaż in-app wishlist onboarding", action: self.showInAppWishlistOnboarding))
            settings.append(Setting(type: .Normal, labelString: "Pokaż in-app paging onboarding", action: self.showInAppPagingOnboarding))
            settings.append(Setting(type: .Normal, labelString: "Pokaż oceń nas (po czasie)", action: self.showRateAppAfterTime))
            settings.append(Setting(type: .Normal, labelString: "Pokaż oceń nas (po zakupie)", action: self.showRateAppAfterBuy))
            settings.append(Setting(type: .Normal, labelString: "Pokaż pytanie o powiadomienia (po czasie)", action: self.showNotificationsAccessAfterTime))
            settings.append(Setting(type: .Normal, labelString: "Pokaż pytanie o powiadomienia (schowek)", action: self.showNotificationsAccessAfterWishlist))
        }
        
        castView.updateData(with: settings)
    }
    
    private func updateSettings() {
        updateSettings(with: userManager.user)
    }
    
    private func updateGender(with gender: Gender) {
        castView.updateData(with: gender)
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Settings)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        markHandoffUrlActivity(withPath: "/")
        castView.deselectRowsIfNeeded()
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
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowOnboaridng))
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
        viewController.preferredContentSize = Dimensions.rateAppPreferredSize
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
        viewController.preferredContentSize = Dimensions.rateAppPreferredSize
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
    }
    
    func sendReportPressed() {
        castView.deselectRowsIfNeeded()
        
        guard MFMailComposeViewController.canSendMail() else {
            toastManager.showMessage(tr(.SettingsSendReportMailNotConfigured))
            return
        }
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setSubject(tr(.SettingsSendReportTitle))
        viewController.setToRecipients([Constants.reportEmail])
        if let deviceInfo = generateReportDeviceInfo() {
            viewController.addAttachmentData(deviceInfo, mimeType: "text/plain", fileName: "report.txt")
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    private func didChange(gender gender: Gender) {
        logAnalyticsEvent(AnalyticsEventId.ProfileGenderChoice(gender.rawValue))
        userManager.gender = gender
    }
    
    private func generateReportDeviceInfo() -> NSData? {
        let device = UIDevice.currentDevice()
        
        var deviceInfo = ""
        deviceInfo += "systemInfo: \(device.systemName), \(device.systemVersion)\n"
        deviceInfo += "deviceInfo: \(device.name), \(device.model), \(device.screenType.rawValue), \(device.modelName)\n"
        deviceInfo += "appInfo: \(NSBundle.appVersionNumber), \(NSBundle.appBuildNumber)\n"
        deviceInfo += "preferredLanguages: \(NSLocale.preferredLanguages())\n"
        return deviceInfo.dataUsingEncoding(NSUTF8StringEncoding)
    }
}

extension SettingsViewController: SigningNavigationControllerDelegate {
    func signingWantsDismiss(navigationController: SigningNavigationController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signingDidLogIn(navigationController: SigningNavigationController) {
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

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}