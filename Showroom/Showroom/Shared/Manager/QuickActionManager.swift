import UIKit
import RxSwift

enum ShortcutIdentifier: String {
    case Dashboard, Search, Basket, Wishlist, Settings
    
    init?(fullType: String) {
        guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
        self.init(rawValue: last)
    }
    
    private var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
    
    private var localizedTitle: String {
        switch self {
        case .Dashboard: return tr(.QuickActionDashboard)
        case .Search: return tr(.QuickActionSearch)
        case .Basket: return tr(.QuickActionBasket)
        case .Wishlist: return tr(.QuickActionWishlist)
        case .Settings: return tr(.QuickActionSettings)
        }
    }
    
    private var shortcutIcon: UIApplicationShortcutIcon {
        switch self {
        case .Dashboard: return UIApplicationShortcutIcon(templateImageName: "ic_home")
        case .Search: return UIApplicationShortcutIcon(templateImageName: "ic_browse")
        case .Basket: return UIApplicationShortcutIcon(templateImageName: "ic_bag")
        case .Wishlist: return UIApplicationShortcutIcon(templateImageName: "ic_favorites")
        case .Settings: return UIApplicationShortcutIcon(templateImageName: "ic_settings")
        }
        
    }
}

protocol QuickActionManagerDelegate: class {
    func quickActionManager(manager: QuickActionManager, didTapShortcut shortcut: ShortcutIdentifier)
}

class QuickActionManager {
    
    private let userManager: UserManager
    private let basketManager: BasketManager
    private let wishlistManager: WishlistManager
    private let disposeBag = DisposeBag()
    
    private let staticShortcutIdentifiers: [ShortcutIdentifier] = [.Search]
    
    var basket: Basket? { return basketManager.state.basket }
    var wishlist: [ListProduct] { return wishlistManager.state.wishlist }
    var shouldSkipStartScreen: Bool { return userManager.shouldSkipStartScreen }
    
    weak var delegate: QuickActionManagerDelegate?
    private let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
        self.basketManager = resolver.resolve(BasketManager.self)
        self.wishlistManager = resolver.resolve(WishlistManager.self)
        
        userManager.shouldSkipStartScreenObservable
            .subscribeNext {
                logInfo("shouldSkipStartScreenObservable onNext action, value: \($0)")
                self.updateQuickActions(shouldSkipStartScreen: $0, basket: self.basket, wishlist: self.wishlist)
            }.addDisposableTo(disposeBag)
        
        basketManager.state.basketObservable
            .subscribeNext {
                logInfo("basket state onNext action, value: \($0)")
                self.updateQuickActions(shouldSkipStartScreen: self.shouldSkipStartScreen, basket: $0, wishlist: self.wishlist)
            }.addDisposableTo(disposeBag)
        
        wishlistManager.state.wishlistObservable
            .subscribeNext {
                logInfo("wishlist state onNext action, value: \($0)")
                self.updateQuickActions(shouldSkipStartScreen: self.shouldSkipStartScreen, basket: self.basket, wishlist: $0)
            }.addDisposableTo(disposeBag)
    }
    
    func updateQuickActions(shouldSkipStartScreen shouldSkipStartScreen: Bool, basket: Basket?, wishlist: [ListProduct]) {
        var shortcutItems = [UIApplicationShortcutItem]()
        
        guard shouldSkipStartScreen else {
            UIApplication.sharedApplication().shortcutItems?.removeAll()
            return
        }
        
        shortcutItems = self.staticShortcutIdentifiers.map { shortcutId in
            return UIApplicationShortcutItem(type: shortcutId.type, localizedTitle: shortcutId.localizedTitle, localizedSubtitle: nil, icon: shortcutId.shortcutIcon, userInfo: nil)
        }
        
        if let productCount = basket?.productsAmount, let basketItem = dynamicShortcutItem(.Basket, productCount: productCount) {
            shortcutItems.append(basketItem)
        }
        
        if let wishlistItem = dynamicShortcutItem(.Wishlist, productCount: UInt(wishlist.count)) {
            shortcutItems.append(wishlistItem)
        }
        
        UIApplication.sharedApplication().shortcutItems = shortcutItems
    }
    
    func dynamicShortcutItem(shortcutId: ShortcutIdentifier, productCount: UInt) -> UIApplicationShortcutItem? {
        guard productCount != 0 else { return nil }
        
        switch shortcutId {
        case .Basket, .Wishlist:
            let title = shortcutId.localizedTitle
            let subtitile: String = { _ in
                switch productCount {
                case 1: return "\(productCount) \(tr(.QuickActionProductCountOne))"
                case 2...4: return "\(productCount) \(tr(.QuickActionProductCountTwoToFour))"
                case 5..<UInt.max: return "\(productCount) \(tr(.QuickActionProductCountFiveAndMore))"
                default: return ""
                }
            }()
            
            let basketShortcut = UIApplicationShortcutItem(type: shortcutId.type, localizedTitle: title, localizedSubtitle: subtitile, icon: shortcutId.shortcutIcon, userInfo: nil)
            return basketShortcut
            
        default:
            logError("unknown dynamic shortcut item")
            return nil
        }
    }
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcut = ShortcutIdentifier(fullType: shortcutItem.type) else { return false }
        delegate?.quickActionManager(self, didTapShortcut: shortcut)
        return true
    }
}