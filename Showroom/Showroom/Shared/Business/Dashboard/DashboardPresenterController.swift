import Foundation
import UIKit

class DashboardPresenterController: PresenterViewController, NavigationHandler {
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        contentViewController = resolver.resolve(DashboardNavigationController.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case _ as ShowProductDetailsEvent:
            currentModalViewController = resolver.resolve(ProductDetailsViewController.self)
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .Close:
                currentModalViewController = nil
                return true
            }
        default:
            return false
        }
    }
}
