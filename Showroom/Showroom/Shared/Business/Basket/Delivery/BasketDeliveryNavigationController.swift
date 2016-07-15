import Foundation
import UIKit

protocol BasketDeliveryNavigationControllerDelegate: class {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController)
}

class BasketDeliveryNavigationController: UINavigationController, NavigationHandler {
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
            popViewControllerAnimated(true)
            return true
        case .Close:
            deliveryDelegate?.basketDeliveryWantsDismiss(self)
            return true
        case .ShowCountrySelectionList:
            let viewController = resolver.resolve(BasketCountryViewController.self)
            viewController.resetBackTitle()
            pushViewController(viewController, animated: true)
            return true
        default: return false
        }
    }
}