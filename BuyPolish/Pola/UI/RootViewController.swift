import KVNProgress
import UIKit

final class RootViewController: UITabBarController {
    private let scanCodeViewController: ScanCodeViewController

    init() {
        scanCodeViewController = DI.container.resolve(ScanCodeViewController.self)!
        super.init()

        let scanNVC = UINavigationController(rootViewController: scanCodeViewController)
        let searchVC = AboutWebViewController(url: "https://www.pola-app.pl/", title: "Wyszukiwarka")
        let newsVC = AboutWebViewController(url: "https://www.pola-app.pl/news", title: "Wiadomości")

        if #available(iOS 13.0, *) {
            scanNVC.tabBarItem = UITabBarItem(title: "Skaner kodów",
                                              image: UIImage(systemName: "iphone"), selectedImage: nil)
            searchVC.tabBarItem = UITabBarItem(title: "Wiadomości",
                                               image: UIImage(systemName: "magnifyingglass"),
                                               selectedImage: nil)
            newsVC.tabBarItem = UITabBarItem(title: "Wiadomości",
                                             image: UIImage(systemName: "newspaper"),
                                             selectedImage: nil)
        }

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
        scanCodeViewController.showScanCodeView()
    }

    func showWriteCodeView() {
        scanCodeViewController.showWriteCodeView()
    }
}
