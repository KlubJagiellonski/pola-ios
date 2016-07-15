import Foundation
import UIKit

class DashboardNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private lazy var commonNavigationHandler: CommonNavigationHandler = { [unowned self] in
        return CommonNavigationHandler(with: self, and: self.resolver)
    }()
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        setNavigationBarHidden(true, animated: false)
        let viewController = resolver.resolve(DashboardViewController.self)
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
