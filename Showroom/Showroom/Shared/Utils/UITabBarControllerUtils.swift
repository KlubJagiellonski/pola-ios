import UIKit

extension UITabBarController {
    func index<T>(forViewControllerType tsype: T.Type) -> Int? {
        return viewControllers?.indexOf { $0 is T }
    }
}