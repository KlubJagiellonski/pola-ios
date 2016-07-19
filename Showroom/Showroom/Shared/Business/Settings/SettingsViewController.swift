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
            let settings = [
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
            castView.updateData(with: settings)
        } else {
            let settings = [
                Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed),
                Setting(type: .Login, action: self.loginButtonPressed, secondaryAction: self.createAccountButtonPressed),
                Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed, value: self.userManager.gender),
                Setting(type: .Normal, labelString: tr(.SettingsHistory), action: self.historyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed)
            ]
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        castView.deselectRowsIfNeeded()
    }

    func facebookButtonPressed() {
        logInfo("facebookButtonPressed")
        tryOpenURL(urlOptions: ["fb://profile/159930354087746", "https://www.facebook.com/shwrm"])
    }
    
    func instagramButtonPressed() {
        logInfo("instagramButtonPressed")
        tryOpenURL(urlOptions: ["instagram://user?username=shwrm", "https://www.instagram.com/shwrm"])
    }
    
    func loginButtonPressed() {
        logInfo("loginButtonPressed")
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func createAccountButtonPressed() {
        logInfo("createAccountButtonPressed")
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Register)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func logoutButtonPressed() {
        logInfo("logoutButtonPressed")
        userManager.logout()
    }
    
    func femaleButtonPressed() {
        logInfo("femaleButtonPressed")
        userManager.gender = .Female
    }
    
    func maleButtonPressed() {
        logInfo("maleButtonPressed")
        userManager.gender = .Male
    }
    
    func userDataRowPressed() {
        logInfo("userDataRowPressed")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowUserInfo))
    }

    func historyRowPressed() {
        logInfo("historyRowPressed")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowHistoryOfOrder))
    }
    
    func howToMeasureRowPressed() {
        logInfo("howToMeasureRowPressed")
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsHowToMeasure), url: "https://www.showroom.pl"))
    }
    
    func privacyPolicyRowPressed() {
        logInfo("privacyPolicyRowPressed")
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsPrivacyPolicy), url: "https://www.showroom.pl"))
    }
    
    func frequentQuestionsRowPressed() {
        logInfo("frequentQuestionsRowPressed")
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsFrequentQuestions), url: "https://www.showroom.pl"))
    }
    
    func rulesRowPressed() {
        logInfo("rulesRowPressed")
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsRules), url: "https://www.showroom.pl"))
    }
    
    func contactRowPressed() {
        logInfo("contactRowPressed")
        sendNavigationEvent(ShowSettingsWebViewEvent(title: tr(.SettingsContact), url: "https://www.showroom.pl"))
    }
}