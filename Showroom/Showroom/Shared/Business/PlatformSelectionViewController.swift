import UIKit

class PlatformSelectionViewController: UIViewController, PlatformSelectionViewDelegate {
    
    private var castView: PlatformSelectionView { return view as! PlatformSelectionView }
    
    let languageManager: LanguageManager
    
    init(languageManager: LanguageManager) {
        self.languageManager = languageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PlatformSelectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    func platformSelectionViewDidTapPolish(view: PlatformSelectionView) {
        logInfo("platform selection view did tap polish")
        languageManager.language = .Polish
        languageManager.shouldSkipPlatformSelection = true
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
    
    func platformSelectionViewDidTapGerman(view: PlatformSelectionView) {
        logInfo("platform selection view did tap german")
        languageManager.language = .German
        languageManager.shouldSkipPlatformSelection = true
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
}