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
    
    func changeTabBarAppearanceIfPossible(appearance: TabBarAppearance, animationDuration: Double?) -> Bool {
        logInfo("Change tab bar appearance \(appearance) animation \(animationDuration)")
        guard let mainTabBarController = tabBarController as? MainTabViewController else {
            logInfo("Not MainTabViewController")
            return false
        }
        mainTabBarController.updateTabBarAppearance(appearance, animationDuration: animationDuration)
        return true
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
            fatalError("UIViewController with type \(modalViewController) is required to conform to ExtendedModalViewControllerProtocol")
        }
    }
}

extension UIResponder {
    func markHandoffUrlActivity(withPath path: String) {
        let userActivity = NSUserActivity(activityType: NSBundle.mainBundle().bundleIdentifier!.stringByAppendingString(".browsing"))
        userActivity.webpageURL = NSURL(string: "\(Constants.websiteUrl)\(path)")
        self.userActivity = userActivity
    }
}
