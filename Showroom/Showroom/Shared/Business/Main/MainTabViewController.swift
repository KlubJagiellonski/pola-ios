import Foundation
import UIKit

class MainTabViewController: UITabBarController {
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [
            createDashboardViewController(),
            createSearchViewController(),
            createBasketViewController(),
            createWishlistViewController(),
            createSettingsViewController(),
        ]
        selectedIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - creating child view controllers
    func createDashboardViewController() -> DashboardViewController {
        let viewController = resolver.resolve(DashboardViewController.self)
        viewController.tabBarItem = UITabBarItem(title: tr(.MainTabDashboard), image: nil, selectedImage: nil)
        return viewController
    }
    
    func createSearchViewController() -> SearchViewController {
        let viewController = resolver.resolve(SearchViewController.self)
        viewController.tabBarItem = UITabBarItem(title: tr(.MainTabSearch), image: nil, selectedImage: nil)
        return viewController
    }
    
    func createBasketViewController() -> BasketNavigationController {
        let navigationController = resolver.resolve(BasketNavigationController.self)
        navigationController.tabBarItem = UITabBarItem(title: tr(.MainTabBasket), image: nil, selectedImage: nil)
        return navigationController
    }
    
    func createWishlistViewController() -> WishlistViewController {
        let viewController = resolver.resolve(WishlistViewController.self)
        viewController.tabBarItem = UITabBarItem(title: tr(.MainTabWishlist), image: nil, selectedImage: nil)
        return viewController
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewController = resolver.resolve(SettingsViewController.self)
        viewController.tabBarItem = UITabBarItem(title: tr(.MainTabSettings), image: nil, selectedImage: nil)
        return viewController
    }
}
