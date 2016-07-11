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
            let viewController = resolver.resolve(ProductDetailsViewController.self, argument: showProductDetailsEvent.context)
            showModal(viewController, hideContentView: true, animation: DimModalAnimation(animationDuration: 0.3), completion: nil)
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .Close:
                hideModal(animation: DimModalAnimation(animationDuration: 0.3), completion: nil)
                return true
            default: return false
            }
        default: return false
        }
    }
}