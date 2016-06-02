import Foundation
import UIKit

enum TabBarColor {
    case Blur, White
    var translucent: Bool { return (self == .Blur) }
}

class MainTabViewController: UITabBarController {
    let tabBarItemImageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)  // Center vertically item without title
    let basketItemImageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    
    var tabBarColor: TabBarColor = .Blur
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        tabBar.translucent = tabBarColor.translucent
        
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
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(asset: .Ic_glowna), selectedImage: UIImage(asset: .Ic_glowna_blue))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createSearchViewController() -> SearchViewController {
        let viewController = resolver.resolve(SearchViewController.self)
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(asset: .Ic_przegladaj), selectedImage: UIImage(asset: .Ic_przegladaj_blue))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createBasketViewController() -> BasketNavigationController {
        let navigationController = resolver.resolve(BasketNavigationController.self)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(asset: .Ic_koszyk), selectedImage: UIImage(asset: .Ic_koszyk_blue))
        navigationController.tabBarItem.imageInsets = basketItemImageInsets
        return navigationController
    }
    
    func createWishlistViewController() -> WishlistViewController {
        let viewController = resolver.resolve(WishlistViewController.self)
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(asset: .Ic_ulubione), selectedImage: UIImage(asset: .Ic_ulubione_blue))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewController = resolver.resolve(SettingsViewController.self)
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(asset: .Ic_profil), selectedImage: UIImage(asset: .Ic_profil_blue))
        viewController.tabBarItem.imageInsets = tabBarItemImageInsets
        return viewController
    }
}
