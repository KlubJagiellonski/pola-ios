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
    func resetBackTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func applyBlackCloseButton(target target: AnyObject?, action: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_close), style: .Plain, target: target, action: action)
    }
    
    func createBlueTextBarButtonItem(title title: String, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(title: title, style: .Plain, target: target, action: action)
        let textAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Blue),
            NSFontAttributeName: UIFont(fontType: .NavigationBarButton)
        ]
        buttonItem.setTitleTextAttributes(textAttributes, forState: .Normal)
        return buttonItem
    }
    
    func changeTabBarAppearanceIfPossible(appearance: TabBarAppearance, animationDuration: Double?) -> Bool {
        guard let mainTabBarController = tabBarController as? MainTabViewController else {
            return false
        }
        mainTabBarController.updateTabBarAppearance(appearance, animationDuration: animationDuration)
        return true
    }
}
