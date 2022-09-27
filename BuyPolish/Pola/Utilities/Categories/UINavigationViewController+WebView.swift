import UIKit

extension UINavigationController {
    static func makeForWebView(rootViewController: UIViewController) -> UINavigationController {
        let nvc = UINavigationController(rootViewController: rootViewController)
        nvc.navigationBar.tintColor = Theme.defaultTextColor
        nvc.navigationBar.isTranslucent = false
        nvc.navigationBar.backgroundColor = Theme.mediumBackgroundColor
        return nvc
    }
}
