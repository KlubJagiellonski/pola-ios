import Foundation
import UIKit

class BasketNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private lazy var commonNavigationHandler: CommonNavigationHandler = { [unowned self] in
        return CommonNavigationHandler(hideNavigationBarForFirstView: false, with: self, and: self.resolver)
        }()
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        
        let viewController = resolver.resolve(BasketViewController.self)
        viewController.navigationItem.title = tr(.MainTabBasket)
        viewController.resetBackTitle()
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        return commonNavigationHandler.handleNavigationEvent(event)
    }
}

extension BasketNavigationController: MainTabChild {
    func popToFirstView() {
        logInfo("Poping to first view")
        popToRootViewControllerAnimated(true)
    }
}