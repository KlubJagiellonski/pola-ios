import Foundation
import UIKit

class DashboardNavigationController: UINavigationController, NavigationHandler {
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentStyle()
        setNavigationBarHidden(true, animated: false)
        
        let viewController = resolver.resolve(DashboardViewController.self)
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(forLink link: String) {
        //todo deeplink handling
        setNavigationBarHidden(false, animated: true)
        let viewController = resolver.resolve(CategoryProductListViewController.self, argument: Category(id: 1, name: "Sukienki i tuniki"))
        viewController.contentInset = UIEdgeInsetsMake(topLayoutGuide.length + navigationBar.bounds.height, 0, bottomLayoutGuide.length, 0)
        viewController.applyBlackBackButton(target: self, action: #selector(DashboardNavigationController.didTapBackButton))
        pushViewController(viewController, animated: true)
    }
    
    func didTapBackButton() {
        // this is correct only when first vc have navigationbar and all next vcs doesn't have. If this will change we should make some nicer approach 
        if viewControllers.count == 2 {
            setNavigationBarHidden(true, animated: true)
        }
        popViewControllerAnimated(true)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let linkEvent as ShowItemForLinkEvent:
            showView(forLink: linkEvent.link)
            return true
        default:
            return false
        }
    }
}
