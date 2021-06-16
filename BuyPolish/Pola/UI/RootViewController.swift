import UIKit

final class RootViewController: UINavigationController {
    init() {
        super.init(rootViewController: DI.container.resolve(ScanCodeViewController.self)!)

        isNavigationBarHidden = true
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var scanCodeViewController: ScanCodeViewController! {
        viewControllers.first as? ScanCodeViewController
    }

    func showScanCodeView() {
        scanCodeViewController.showScanCodeView()
    }

    func showWriteCodeView() {
        scanCodeViewController.showWriteCodeView()
    }
}
