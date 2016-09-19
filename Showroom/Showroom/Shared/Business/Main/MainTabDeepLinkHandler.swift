import Foundation
import JLRoutes

final class MainTabDeepLinkHandler: DeepLinkingHandler {
    private let urlRouter = JLRoutes()
    weak var mainTabViewController: MainTabViewController?
    
    init() {
        configureRouter()
    }
    
    func handleOpen(withURL url: NSURL) -> Bool {
        guard self.mainTabViewController != nil else {
            logError("No mainTabViewController. It propably menas that it was not set")
            return false
        }
        return urlRouter.routeURL(url)
    }
    
    private func configureRouter() {
        urlRouter.addRoute("/:host/c/cart/view", priority: 1) { [weak self](parameters: [NSObject: AnyObject]!) in
            logInfo("Handling cart route \(parameters)")
            
            guard let `self` = self, let mainTabViewController = self.mainTabViewController else { return false }
            let discountCode = parameters["coupon"] as? String
            
            mainTabViewController.updateSelectedIndex(forControllerType: MainTabChildControllerType.Basket)
            if let commonPresenterController = mainTabViewController.selectedViewController as? CommonPresenterController,
                let basketNavigationController = commonPresenterController.contentViewController as? BasketNavigationController {
                basketNavigationController.didReceiveCartLink(withNewDiscountCode: discountCode)
            } else {
                logError("Selected view controller should be of type `BasketNavigationController` and is of type \(self.mainTabViewController?.selectedViewController) with main tab \(self.mainTabViewController)")
            }
            return true
        }
        
        urlRouter.addRoute("*", priority: 0) { [weak self](parameters: [NSObject: AnyObject]!) in
            logInfo("Handling * route \(parameters)")
            
            guard let `self` = self, let mainTabViewController = self.mainTabViewController else { return false }
            guard let url = parameters[kJLRouteURLKey] as? NSURL else {
                logError("Url without route url key")
                return false
            }
            
            let searchIndex = MainTabChildControllerType.Search.rawValue
            guard let deepLinkingHandler = mainTabViewController.viewControllers?[searchIndex] as? DeepLinkingHandler else {
                return false
            }
            let handled = deepLinkingHandler.handleOpen(withURL: url)
            if handled {
                logInfo("Url handled")
                mainTabViewController.selectedIndex = searchIndex
            }
            return handled
        }
        
        urlRouter.unmatchedURLHandler = { (routes: JLRoutes, url: NSURL?, parameters: [NSObject: AnyObject]?) in
            logError("Received unmatched url handler. It means that wildcard not work for url \(url)")
        }
    }
}
