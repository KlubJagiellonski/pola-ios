import KVNProgress
import UIKit

final class RootViewController: UINavigationController {
    private let scanCodeViewController: ScanCodeViewController
    
    init() {
        scanCodeViewController = DI.container.resolve(ScanCodeViewController.self)!
        super.init(rootViewController: scanCodeViewController)
        

        isNavigationBarHidden = true

        let config = KVNProgressConfiguration.default()
        config?.stopColor = R.color.clearColor()
        config?.errorColor = R.color.clearColor()
        config?.statusColor = R.color.clearColor()
        config?.successColor = R.color.clearColor()
        config?.backgroundTintColor = R.color.strongBackgroundColor()
        config?.circleFillBackgroundColor = R.color.strongBackgroundColor()
        config?.circleStrokeForegroundColor = R.color.clearColor()

        KVNProgress.setConfiguration(config)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        scanCodeViewController = DI.container.resolve(ScanCodeViewController.self)!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showScanCodeView() {
        scanCodeViewController.showScanCodeView()
    }

    func showWriteCodeView() {
        scanCodeViewController.showWriteCodeView()
    }
}
