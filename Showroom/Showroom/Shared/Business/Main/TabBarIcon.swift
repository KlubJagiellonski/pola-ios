import UIKit

enum TabBarIcon {
    case Dashboard
    case Search
    case Basket
    case Wishlist
    case Settings
    
    private func image(selected selected: Bool) -> UIImage {
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
}

extension UITabBarItem {
    convenience init(tabBarIcon: TabBarIcon, badgeValue: Int? = nil) {
        self.init(title: nil, image: tabBarIcon.image(selected: false), selectedImage: tabBarIcon.image(selected: true))
    }
}