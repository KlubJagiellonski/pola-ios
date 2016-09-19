import Foundation
import UIKit
import RxSwift

enum TabBarAppearance { case Visible, Hidden }

protocol MainTabChild {
    func popToFirstView()
}

enum MainTabChildControllerType: Int {
    case Dashboard = 0, Search, Basket, Wishlist, Settings
    
    private func tabBarImage(selected selected: Bool) -> UIImage {
        switch (self, selected) {
        case (Dashboard, true): return UIImage(asset: .Ic_home_selected)
        case (Dashboard, false): return UIImage(asset: .Ic_home)
            
        case (Search, true): return UIImage(asset: .Ic_browse_selected)
        case (Search, false): return UIImage(asset: .Ic_browse)
            
        case (Basket, true): return UIImage(asset: .Ic_bag_selected)
        case (Basket, false): return UIImage(asset: .Ic_bag)
            
        case (Wishlist, true): return UIImage(asset: .Ic_favorites_selected)
        case (Wishlist, false): return UIImage(asset: .Ic_favorites)
            
        case (Settings, true): return UIImage(asset: .Ic_settings_selected)
        case (Settings, false): return UIImage(asset: .Ic_settings)
        }
    }
    
    private func tabBarInsets() -> UIEdgeInsets {
        switch self {
        case .Dashboard:
            return UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        case .Basket:
            return UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        default:
            return UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    private func createViewController(resolver: DiResolver) -> UIViewController {
        switch self {
        case .Dashboard:
            return resolver.resolve(DashboardNavigationController.self)
        case .Search:
            return resolver.resolve(SearchNavigationController.self)
        case .Basket:
            return resolver.resolve(BasketNavigationController.self)
        case .Wishlist:
            return resolver.resolve(WishlistNavigationController.self)
        case .Settings:
            return resolver.resolve(SettingsNavigationController.self)
        }
    }
}

class MainTabViewController: UITabBarController, NavigationHandler {
    private let badgesContainerView = TabBarItemBadgeContainerView()
    var basketBadgeValue: UInt {
        set { badgesContainerView.basketBadgeValue = newValue }
        get { return badgesContainerView.basketBadgeValue }
    }    
    var wishlistBadgeValue: UInt {
        set { badgesContainerView.wishlistBadgeValue = newValue }
        get { return badgesContainerView.wishlistBadgeValue }
    }
    
    private(set) var appearance: TabBarAppearance {
        didSet {            
            guard appearance != oldValue else { return }
            let height = self.tabBar.frame.height
            let offsetY = (appearance == .Hidden) ? height : -height
            tabBar.center.y += offsetY
            badgesContainerView.center.y += offsetY
        }
    }
    
    private let resolver: DiResolver
    private let basketManager: BasketManager
    private let wishlistManager: WishlistManager
    private let disposeBag = DisposeBag()
    private let deepLinkHandler = MainTabDeepLinkHandler()
    
    init(resolver: DiResolver, basketManager: BasketManager, wishlistManager: WishlistManager) {
        self.resolver = resolver
        self.basketManager = basketManager
        self.wishlistManager = wishlistManager
        appearance = .Visible
        
        super.init(nibName: nil, bundle: nil)
        
        deepLinkHandler.mainTabViewController = self
        
        tabBar.translucent = true
        tabBar.tintColor = UIColor(named: .Blue)
        
        delegate = self
        
        viewControllers = [
            createChildViewController(forType: .Dashboard),
            createChildViewController(forType: .Search),
            createChildViewController(forType: .Basket),
            createChildViewController(forType: .Wishlist),
            createChildViewController(forType: .Settings),
        ]
        selectedIndex = 0
        
        basketManager.state.basketObservable.subscribeNext { [weak self] basket in
            self?.onBasketChanged(basket)
            }.addDisposableTo(disposeBag)
        wishlistManager.state.wishlistObservable.subscribeNext { [weak self] wishlist in
            self?.onWishlistChanged(wishlist)
            }.addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(badgesContainerView)
        
        basketBadgeValue = basketManager.state.basket?.productsAmount ?? 0
        wishlistBadgeValue = UInt(wishlistManager.state.wishlist.count)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        badgesContainerView.frame = tabBar.frame
    }
    
    func updateTabBarAppearance(appearance: TabBarAppearance, animationDuration: Double?) {
        logInfo("Updating tab bar appearance \(appearance) animation \(animationDuration)")
        UIView.animateWithDuration(animationDuration ?? 0, delay: 0.0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            self.appearance = appearance
            }, completion: nil)
    }
    
    func handleQuickActionShortcut(shortcut: ShortcutIdentifier) {
        switch shortcut {
        case .Dashboard:
            logInfo("handleQuickActionShortcut: Dashboard")
            selectedIndex = MainTabChildControllerType.Dashboard.rawValue
        case .Search:
            logInfo("handleQuickActionShortcut: Search")
            selectedIndex = MainTabChildControllerType.Search.rawValue
        case .Basket:
            logInfo("handleQuickActionShortcut: Basket")
            selectedIndex = MainTabChildControllerType.Basket.rawValue
        case .Wishlist:
            logInfo("handleQuickActionShortcut: Wishlist")
            selectedIndex = MainTabChildControllerType.Wishlist.rawValue
        case .Settings:
            logInfo("handleQuickActionShortcut: Basket")
            selectedIndex = MainTabChildControllerType.Settings.rawValue
        }
    }
    
    func updateSelectedIndex(forControllerType controllerType: MainTabChildControllerType) {
        selectedIndex = controllerType.rawValue
    }
    
    private func onBasketChanged(basket: Basket?) {
        logInfo("Basket changed with amount \(basket?.productsAmount)")
        basketBadgeValue = basket?.productsAmount ?? 0
    }
    
    private func onWishlistChanged(wishlist: [WishlistProduct]) {
        logInfo("Wishlist changed with amount \(wishlist.count)")
        wishlistBadgeValue = UInt(wishlist.count)
    }
    
    private func createChildViewController(forType type: MainTabChildControllerType) -> UIViewController {
        let contentViewController = type.createViewController(resolver)
        let viewController = resolver.resolve(CommonPresenterController.self, argument: contentViewController)
        viewController.tabBarItem = UITabBarItem(type: type)
        viewController.tabBarItem.imageInsets = type.tabBarInsets()
        return viewController
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let simpleEvent = event as? SimpleNavigationEvent {
            if simpleEvent.type == .ShowSearch {
                logInfo("Show search")
                selectedIndex = MainTabChildControllerType.Search.rawValue
                return true
            }
        }
        return false
    }
}

extension MainTabViewController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        logInfo("Handling url \(url)")
        return deepLinkHandler.handleOpen(withURL: url)
    }
}

extension MainTabViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if let child = viewController as? MainTabChild where viewController == selectedViewController {
            child.popToFirstView()
        }
        return true
    }
}

extension UITabBarItem {
    convenience init(type: MainTabChildControllerType, badgeValue: Int? = nil) {
        self.init(title: nil, image: type.tabBarImage(selected: false), selectedImage: type.tabBarImage(selected: true))
    }
}