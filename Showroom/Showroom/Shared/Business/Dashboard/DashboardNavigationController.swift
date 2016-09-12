import Foundation
import UIKit

final class DashboardNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private lazy var commonNavigationHandler: CommonNavigationHandler = { [unowned self] in
        return CommonNavigationHandler(hideNavigationBarForFirstView: true, with: self, and: self.resolver)
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

extension DashboardNavigationController: MainTabChild {
    func popToFirstView() {
        logInfo("Popping ot first view")
        popToRootViewControllerAnimated(true)
    }
}

extension DashboardNavigationController: PresenterContentChildProtocol {
    func presenterWillApear() {
        if let dashboardViewController = viewControllers.first as? DashboardViewController where viewControllers.count == 1 {
            dashboardViewController.updateData()
        }
    }
}