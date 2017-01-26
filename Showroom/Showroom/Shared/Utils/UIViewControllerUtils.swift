import Foundation
import UIKit

protocol ContentInsetHandler: class {
    var contentInset: UIEdgeInsets { get set }
}

protocol ExtendedModalViewController: class {
    func forceCloseWithoutAnimation()
}

extension UIViewController {    
    func resetBackTitle(title: String = "") {
        let button = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
        button.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0), forBarMetrics: .Default)
        navigationItem.backBarButtonItem = button
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
    
    func tryOpenURL(urlOptions urls: [String]) {
        logInfo("Try open urls \(urls)")
        let application = UIApplication.sharedApplication()
        for urlString in urls {
            let url: NSURL = NSURL(string: urlString)!
            if application.canOpenURL(url) {
                application.openURL(url)
                return
            }
        }
    }
    
    func forceCloseModal() {
        logInfo("Force close modal \(presentedViewController)")
        guard let modalViewController = presentedViewController else { return }
        
        if let extendedModalViewController = modalViewController as? ExtendedModalViewController {
            extendedModalViewController.forceCloseWithoutAnimation()
        } else if modalViewController is UIActivityViewController {
            dismissViewControllerAnimated(false, completion: nil)
        } else {
            logError("UIViewController with type \(modalViewController) is required to conform to ExtendedModalViewController")
        }
    }
}

// MARK:- Status bar handling

protocol StatusBarAppearanceHandling {
    var wantsHandleStatusBarAppearance: Bool { get }
}

// MARK:- Tab bar handling

protocol TabBarStateDataSource: class {
    var prefersTabBarHidden: Bool { get }
}

protocol TabBarHandler: class {
    func dataSourceForTabBarHidden() -> TabBarStateDataSource?
}

extension UIViewController {
    func setNeedsTabBarAppearanceUpdate() {
        if let tabBarHandler = self as? TabBarHandler,
            let dataSource = tabBarHandler.dataSourceForTabBarHidden() {
            
            guard let mainTabBarController = tabBarController as? MainTabViewController else {
                logInfo("Not MainTabViewController")
                return
            }
            
            mainTabBarController.updateTabBarAppearance(dataSource.prefersTabBarHidden ? .Hidden : .Visible)
            return
        }
        
        if let parentViewController = parentViewController {
            parentViewController.setNeedsTabBarAppearanceUpdate()
            return
        }
        
        logError("setNeedsTabBarAppearanceUpdate not handled")
    }
}
