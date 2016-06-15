import Foundation
import UIKit

protocol BasketDeliveryNavigationControllerDelegate: class {
    func basketDeliveryWantsDismiss(viewController: BasketDeliveryNavigationController)
}

class BasketDeliveryNavigationController: UINavigationController, NavigationHandler {
    weak var deliveryDelegate: BasketDeliveryNavigationControllerDelegate?
    
    init(resolver: DiResolver) {
        super.init(nibName: nil, bundle: nil)
        
        navigationBarHidden = true
        viewControllers = [resolver.resolve(BasketDeliveryViewController.self)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        deliveryDelegate?.basketDeliveryWantsDismiss(self)
        return true
    }
}