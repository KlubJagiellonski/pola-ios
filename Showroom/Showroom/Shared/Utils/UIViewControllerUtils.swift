import Foundation
import UIKit

protocol ExtendedView: class {
    var extendedContentInset: UIEdgeInsets? { get set }
}

protocol ExtendedViewController: class {
    var extendedView: ExtendedView { get }
    var extendedContentInset: UIEdgeInsets? { get set }
}

extension ExtendedViewController where Self: UIViewController {
    var extendedView: ExtendedView {
        get { return self.view as! ExtendedView }
    }
    
    var extendedContentInset: UIEdgeInsets? {
        set { extendedView.extendedContentInset = newValue }
        get { return extendedView.extendedContentInset }
    }
}

extension UIViewController {
    func applyBlackBackButton(target target: AnyObject?, action: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_back), style: .Plain, target: target, action: action)
    }
    
    func applyBlackCloseButton(target target: AnyObject?, action: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_close), style: .Plain, target: target, action: action)
    }
    
    func changeTabBarAppearanceIfPossible(appearance: TabBarAppearance, animationDuration: Double?) -> Bool {
        guard let mainTabBarController = tabBarController as? MainTabViewController else {
            return false
        }
        mainTabBarController.updateTabBarAppearance(appearance, animationDuration: animationDuration)
        return true
    }
}
