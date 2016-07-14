import Foundation
import UIKit
import RxSwift

class SettingsViewController: UIViewController {
    private let userManager: UserManager
    private let disposeBag = DisposeBag()
    private var castView: SettingsView { return view as! SettingsView }
    
    private var firstLayoutSubviewsPassed = false
   
    var settings = [Setting]()
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        
        super.init(nibName: nil, bundle: nil)
        self.userManager.userObservable.subscribeNext(updateSettings).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSettings(with user: User?) {
        if let user = user {
            let settings = [
                Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed),
                Setting(type: .Logout, labelString: tr(.CommonGreeting(user.name)), action: self.logoutButtonPressed),
                Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed),
                Setting(type: .Normal, labelString: tr(.SettingsUserData), action: self.userDataRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHistory), action: self.historyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed)
            ]
            castView.updateData(settings)
        } else {
            let settings = [
                Setting(type: .Header, action: self.facebookButtonPressed, secondaryAction: self.instagramButtonPressed),
                Setting(type: .Login, action: self.loginButtonPressed, secondaryAction: self.createAccountButtonPressed),
                Setting(type: .Gender, labelString: tr(.SettingsDefaultOffer), action: self.femaleButtonPressed, secondaryAction: self.maleButtonPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHistory), action: self.historyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsHowToMeasure), action: self.howToMeasureRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsPrivacyPolicy), action: self.privacyPolicyRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsFrequentQuestions), action: self.frequentQuestionsRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsRules), action: self.rulesRowPressed),
                Setting(type: .Normal, labelString: tr(.SettingsContact), action: self.contactRowPressed)
            ]
            castView.updateData(settings)
        }
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

    func facebookButtonPressed() {
        logInfo("facebooButtonPressed")
    }
    
    func instagramButtonPressed() {
        logInfo("instagramButtonPressed")
    }
    
    func loginButtonPressed() {
        logInfo("loginButtonPressed")
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Login)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func createAccountButtonPressed() {
        let viewController = resolver.resolve(SigningNavigationController.self, argument: SigningMode.Register)
        presentViewController(viewController, animated: true, completion: nil)
        logInfo("createAccountButtonPressed")
    }
    
    func logoutButtonPressed() {
        logInfo("logoutButtonPressed")
        userManager.logout()
    }
    
    func femaleButtonPressed() {
        logInfo("femaleButtonPressed")
    }
    
    func maleButtonPressed() {
        logInfo("maleButtonPressed")
    }
    
    func userDataRowPressed() {
        logInfo("userDataRowPressed")
    }

    func historyRowPressed() {
        logInfo("historyRowPressed")
    }
    
    func howToMeasureRowPressed() {
        logInfo("howToMeasureRowPressed")
    }
    
    func privacyPolicyRowPressed() {
        logInfo("privacyPolicyRowPressed")
    }
    
    func frequentQuestionsRowPressed() {
        logInfo("frequentQuestionsRowPressed")
    }
    
    func rulesRowPressed() {
        logInfo("rulesRowPressed")
    }
    
    func contactRowPressed() {
        logInfo("contactRowPressed")
    }
}