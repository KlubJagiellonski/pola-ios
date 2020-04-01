import UIKit

final class RootViewController: UINavigationController {
    
    init() {
        super.init(rootViewController: DI.container.resolve(ScanCodeViewController.self)!)
        
        isNavigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scanCodeViewController: ScanCodeViewController {
        viewControllers.first as! ScanCodeViewController
    }
    
    func showScanCodeView() {
        scanCodeViewController.showScanCodeView()
    }
    
    func showWriteCodeView() {
        scanCodeViewController.showWriteCodeView()
    }
    
}
