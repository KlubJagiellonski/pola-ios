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
    
    func didReceiveCartLink(withNewDiscountCode discountCode: String?, link: NSURL?) {
        logInfo("Received cart link with discount code \(discountCode)")
        popToRootViewControllerAnimated(true)
        guard let discountCode = discountCode, let basketViewController = viewControllers.first as? BasketViewController else {
            return
        }
        basketViewController.didReceiveNewDiscountCode(discountCode, link: link)
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
