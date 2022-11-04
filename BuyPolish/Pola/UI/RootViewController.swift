import KVNProgress
import UIKit

final class RootViewController: UITabBarController {
    private let scanCodeViewController: ScanCodeViewController

    init() {
        scanCodeViewController = DI.container.resolve(ScanCodeViewController.self)!
        super.init()

        let scanNVC = scanCodeViewController
        let searchVC = TabWebViewController(url: "https://www.pola-app.pl/")
        let newsVC = TabWebViewController(url: "https://www.pola-app.pl/news")

        let strings = R.string.localizable.self
        scanNVC.tabBarItem = UITabBarItem(title: strings.mainTabScanner(), imageSystemName: "iphone")
        searchVC.tabBarItem = UITabBarItem(title: strings.mainTabSearch(), imageSystemName: "magnifyingglass")
        newsVC.tabBarItem = UITabBarItem(title: strings.mainTabNews(), imageSystemName: "newspaper")

        viewControllers = [scanNVC, searchVC, newsVC]

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
        switchToScanCodeViewController()
        scanCodeViewController.showScanCodeView()
    }

    func showWriteCodeView() {
        switchToScanCodeViewController()
        scanCodeViewController.showWriteCodeView()
    }

    private func switchToScanCodeViewController() {
        selectedIndex = 0
    }
}
