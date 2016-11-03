import Foundation
import UIKit

protocol BasketDeliveryNavigationControllerDelegate: class {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController, animated: Bool)
}

final class BasketDeliveryNavigationController: UINavigationController, NavigationHandler {
    weak var deliveryDelegate: BasketDeliveryNavigationControllerDelegate?
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhitePopupStyle()
        
        let viewController = resolver.resolve(BasketDeliveryViewController.self)
        viewController.resetBackTitle()
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        guard let simpleEvent = event as? SimpleNavigationEvent else { return false }
        
        switch simpleEvent.type {
        case .Back:
            logInfo("Back to previous view controller")
            popViewControllerAnimated(true)
            return true
        case .Close:
            logInfo("Closing basket delivery")
            deliveryDelegate?.basketDeliveryWantsDismiss(self, animated: true)
            return true
        case .ShowCountrySelectionList:
            logInfo("Showing country selection list")
            let viewController = resolver.resolve(BasketCountryViewController.self)
            viewController.resetBackTitle()
            pushViewController(viewController, animated: true)
            return true
        default: return false
        }
    }
}

extension BasketDeliveryNavigationController: ExtendedModalViewController {
    func forceCloseWithoutAnimation() {
        deliveryDelegate?.basketDeliveryWantsDismiss(self, animated: false)
    }
}
