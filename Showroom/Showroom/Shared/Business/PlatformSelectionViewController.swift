import UIKit

final class PlatformSelectionViewController: UIViewController, PlatformSelectionViewDelegate {
    
    private var castView: PlatformSelectionView { return view as! PlatformSelectionView }
    
    private let configurationManager: ConfigurationManager
    
    init(configurationManager: ConfigurationManager) {
        self.configurationManager = configurationManager
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
        configurationManager.platform = .Polish
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
    
    func platformSelectionViewDidTapGerman(view: PlatformSelectionView) {
        logInfo("platform selection view did tap german")
        configurationManager.platform = .German
        sendNavigationEvent(SimpleNavigationEvent(type: .PlatformSelectionEnd))
    }
}
