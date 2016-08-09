import Foundation
import UIKit
import RxSwift

class SettingsViewController: UIViewController {
    private let userManager: UserManager
    private let disposeBag = DisposeBag()
    private var castView: SettingsView { return view as! SettingsView }
    
    private var firstLayoutSubviewsPassed = false
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        
        super.init(nibName: nil, bundle: nil)
        self.userManager.userObservable.subscribeNext(updateSettings).addDisposableTo(disposeBag)
        self.userManager.genderObservable.subscribeNext(updateGender).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSettings(with user: User?) {
        if let user = user {
            var settings = [
                Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed),
                Setting(type: .Logout, labelString: tr(.CommonGreeting(user.name)), action: self.logoutButtonPressed),
                Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed, value: self.userManager.gender),
                Setting(type: .Normal, labelString: tr(.SettingsUserData), action: self.userDataRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHistory), action: self.historyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed)
            ]
            if !Constants.isAppStore {
                settings.append(Setting(type: .Normal, labelString: "Pokaż onboarding", action: self.showOnboarding))
            }
            castView.updateData(with: settings)
        } else {
            var settings = [
                Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed),
                Setting(type: .Login, action: self.loginButtonPressed, secondaryAction: self.createAccountButtonPressed),
                Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed, value: self.userManager.gender),
                Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed)
            ]
            if !Constants.isAppStore {
                settings.append(Setting(type: .Normal, labelString: "Pokaż onboarding", action: self.showOnboarding))
            }
            castView.updateData(with: settings)
        }
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
    
    func userDataRowPressed() {
        logInfo("userDataRowPressed")
        logAnalyticsShowScreen(.UserData)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsUserData), url: "https://www.showroom.pl/c/data"))
    }

    func historyRowPressed() {
        logInfo("historyRowPressed")
        logAnalyticsShowScreen(.OrdersHistory)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsHistory), url: "https://www.showroom.pl/c/orders"))
    }
    
    func howToMeasureRowPressed() {
        logInfo("howToMeasureRowPressed")
        
        logAnalyticsShowScreen(.HowToMeasure)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsHowToMeasure), url: "https://www.showroom.pl/d/jak-sie-mierzyc"))
    }
    
    func privacyPolicyRowPressed() {
        logInfo("privacyPolicyRowPressed")
        logAnalyticsShowScreen(.Policy)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsPrivacyPolicy), url: "https://dysk.shwrm.net/marketing/images/pliki/SHWRM5PolitykaPrywatnosci.pdf"))
    }
    
    func frequentQuestionsRowPressed() {
        logInfo("frequentQuestionsRowPressed")
        logAnalyticsShowScreen(.FAQ)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsFrequentQuestions), url: "https://www.showroom.pl/czeste-pytania"))
    }
    
    func rulesRowPressed() {
        logInfo("rulesRowPressed")
        logAnalyticsShowScreen(.Rules)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsRules), url: "https://www.showroom.pl/d/nowy-regulamin"))
    }
    
    func contactRowPressed() {
        logInfo("contactRowPressed")
        logAnalyticsShowScreen(.Contact)
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsContact), url: "https://www.showroom.pl/kontakt"))
    }
    
    func showOnboarding() {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowOnboaridng))
    }
    
    private func didChange(gender gender: Gender) {
        logAnalyticsEvent(AnalyticsEventId.ProfileGenderChoice(gender.rawValue))
        userManager.gender = gender
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