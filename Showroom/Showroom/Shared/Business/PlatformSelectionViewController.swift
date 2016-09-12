import UIKit

class PlatformSelectionViewController: UIViewController, PlatformSelectionViewDelegate {
    
    private var castView: PlatformSelectionView { return view as! PlatformSelectionView }
    
    let platformManager: PlatformLanguageManager
    
    init(platformManager: PlatformLanguageManager) {
        self.platformManager = platformManager
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
        platformManager.language = .Polish
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
    
    func platformSelectionViewDidTapGerman(view: PlatformSelectionView) {
        logInfo("platform selection view did tap german")
        platformManager.language = .German
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
}