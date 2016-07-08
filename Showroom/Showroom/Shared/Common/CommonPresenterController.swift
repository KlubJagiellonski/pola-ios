import Foundation
import UIKit

class CommonPresenterController: PresenterViewController, NavigationHandler {
    
    let resolver: DiResolver
    
    init(with resolver: DiResolver, contentViewController: UIViewController) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        self.contentViewController = contentViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- NavigationHandler

    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let showProductDetailsEvent as ShowProductDetailsEvent:
            currentModalViewController = resolver.resolve(ProductDetailsViewController.self, argument: showProductDetailsEvent.context)
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .Close:
                currentModalViewController = nil
                return true
            default: return false
            }
        default: return false
        }
    }
}