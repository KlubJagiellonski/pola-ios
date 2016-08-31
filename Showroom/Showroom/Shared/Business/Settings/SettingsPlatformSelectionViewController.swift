import UIKit

class SettingsPlatformSelectionViewController: UIViewController, SettingsPlatformSelectionViewDelegate {
    
    private var castView: SettingsPlatformSelectionView { return view as! SettingsPlatformSelectionView }
    
    let languageManager: LanguageManager
    
    init(languageManager: LanguageManager) {
        self.languageManager = languageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SettingsPlatformSelectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    func settingsPlatformSelectionViewDidTapPolish(view: SettingsPlatformSelectionView) {
        logInfo("settings platform selection view did tap polish")
        languageManager.language = .Polish
        sendNavigationEvent(SimpleNavigationEvent(type: .InvalidateMainTabViewController))
        // TODO: might change: InvalidateMainTabViewController -> PlatformSelectionEnd to show initial onboarding and ask for notifications
    }
    
    func settingsPlatformSelectionViewDidTapGerman(view: SettingsPlatformSelectionView) {
        logInfo("settings platform selection view did tap german")
        languageManager.language = .German
        sendNavigationEvent(SimpleNavigationEvent(type: .InvalidateMainTabViewController))
        // TODO: might change: InvalidateMainTabViewController -> PlatformSelectionEnd to show initial onboarding and ask for notifications
    }
}