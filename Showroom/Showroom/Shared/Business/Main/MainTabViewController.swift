import Foundation
import UIKit
import RxSwift

enum TabBarAppearance { case Visible, Hidden }

class MainTabViewController: UITabBarController {
    static let tabBarItemImageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)  // Center vertically item without title
    static let basketItemImageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    static let dashboardItemImageIsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    
    private let basketBadgeContainerView = TabBarItemBadgeContainerView()
    var basketBadgeValue: UInt {
        set { basketBadgeContainerView.badgeValue = newValue }
        get { return basketBadgeContainerView.badgeValue }
    }
    
    private(set) var appearance: TabBarAppearance {
        didSet {            
            guard appearance != oldValue else { return }
            let height = self.tabBar.frame.height
            let offsetY = (appearance == .Hidden) ? height : -height
            tabBar.center.y += offsetY
            basketBadgeContainerView.center.y += offsetY
        }
    }
    
    private let resolver: DiResolver
    private let basketManager: BasketManager
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver, basketManager: BasketManager) {
        self.resolver = resolver
        self.basketManager = basketManager
        appearance = .Visible
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
        
        basketManager.state.basketObservable.subscribeNext(onBasketChanged).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(basketBadgeContainerView)
        
        basketBadgeValue = basketManager.state.basket?.productsAmount ?? 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        basketBadgeContainerView.frame = tabBar.frame
    }
    
    func onBasketChanged(basket: Basket?) {
        basketBadgeValue = basket?.productsAmount ?? 0
    }
    
    func updateTabBarAppearance(appearance: TabBarAppearance, animationDuration: Double?) {
        UIView.animateWithDuration(animationDuration ?? 0, delay: 0.0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            self.appearance = appearance
            }, completion: nil)
    }

    
    // MARK: - creating child view controllers
    func createDashboardViewController() -> DashboardPresenterController {
        let viewController = resolver.resolve(DashboardPresenterController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Dashboard)
        viewController.tabBarItem.imageInsets = MainTabViewController.dashboardItemImageIsets
        return viewController
    }
    
    func createSearchViewController() -> SearchViewController {
        let viewController = resolver.resolve(SearchViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Search)
        viewController.tabBarItem.imageInsets = MainTabViewController.tabBarItemImageInsets
        return viewController
    }
    
    func createBasketViewController() -> BasketNavigationController {
        let navigationController = resolver.resolve(BasketNavigationController.self)
        navigationController.tabBarItem = UITabBarItem(tabBarIcon: .Basket)
        navigationController.tabBarItem.imageInsets = MainTabViewController.basketItemImageInsets
        return navigationController
    }
    
    func createWishlistViewController() -> WishlistViewController {
        let viewController = resolver.resolve(WishlistViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Wishlist)
        viewController.tabBarItem.imageInsets = MainTabViewController.tabBarItemImageInsets
        return viewController
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewController = resolver.resolve(SettingsViewController.self)
        viewController.tabBarItem = UITabBarItem(tabBarIcon: .Settings)
        viewController.tabBarItem.imageInsets = MainTabViewController.tabBarItemImageInsets
        return viewController
    }
}