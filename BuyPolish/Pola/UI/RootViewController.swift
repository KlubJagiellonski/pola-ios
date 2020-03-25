import UIKit

@objc(BPRootViewController)
class RootViewController: UINavigationController {
    
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
    
    @objc
    func showScanCodeView() {
        scanCodeViewController.showScanCodeView()
    }
    
    @objc
    func showWriteCodeView() {
        scanCodeViewController.showWriteCodeView()
    }
    
}
