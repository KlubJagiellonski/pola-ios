import Foundation
import UIKit

class MainTabViewController: UITabBarController {
    let tabBarItemImageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)  // Center vertically item without title
    let basketItemImageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    
    var iconsVersion: TabBarIconVersion = .Full {
        didSet {
            let newBarIcons: [TabBarIcon] = [.Dashboard(version: iconsVersion), .Search(version: iconsVersion), .Basket(version: iconsVersion), .Wishlist(version: iconsVersion), .Settings(version: iconsVersion)]
            
            for (viewController, newBarIcon) in zip(viewControllers!, newBarIcons) {
                viewController.tabBarItem = UITabBarItem(tabBarIcon: newBarIcon)
                switch newBarIcon {
                case .Basket: viewController.tabBarItem.imageInsets = basketItemImageInsets
                default: viewController.tabBarItem.imageInsets = tabBarItemImageInsets
                }
            }
        }
    }
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        tabBar.translucent = true
        tabBar.tintColor = UIColor(named: .Blue)
        
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
    func createDashboardViewController() -> DashboardPresenterController {
        let viewController = resolver.resolve(DashboardPresenterController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Dashboard(version: iconsVersion))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createSearchViewController() -> SearchViewController {
        let viewController = resolver.resolve(SearchViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Search(version: iconsVersion))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createBasketViewController() -> BasketNavigationController {
        let navigationController = resolver.resolve(BasketNavigationController.self)
        navigationController.tabBarItem = UITabBarItem(tabBarIcon: .Basket(version: iconsVersion))
        navigationController.tabBarItem.imageInsets = basketItemImageInsets
        return navigationController
    }
    
    func createWishlistViewController() -> WishlistViewController {
        let viewController = resolver.resolve(WishlistViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Wishlist(version: iconsVersion))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewController = resolver.resolve(SettingsViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Settings(version: iconsVersion))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
}
