import KVNProgress
import UIKit

final class RootViewController: UINavigationController {
    init() {
        super.init(rootViewController: DI.container.resolve(ScanCodeViewController.self)!)

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
