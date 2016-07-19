import Foundation
import UIKit

class BasketNavigationController: UINavigationController {
    private let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        
        let viewController = resolver.resolve(BasketViewController.self)
        viewController.navigationItem.title = tr(.MainTabBasket)
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasketNavigationController: MainTabChild {
    func popToFirstView() {
        popToRootViewControllerAnimated(true)
    }
}