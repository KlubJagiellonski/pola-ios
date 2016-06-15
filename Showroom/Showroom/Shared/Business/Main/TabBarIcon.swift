import UIKit

enum TabBarIcon {
    case Dashboard(version: TabBarIconVersion)
    case Search(version: TabBarIconVersion)
    case Basket(version: TabBarIconVersion)
    case Wishlist(version: TabBarIconVersion)
    case Settings(version: TabBarIconVersion)
    
    private var image: UIImage {
        switch self {
        case Dashboard(.Full): return UIImage(asset: .Ic_home_full_black)
        case Search(.Full): return UIImage(asset: .Ic_przegladaj)
        case Basket(.Full): return UIImage(asset: .Ic_bag_full_black)
        case Wishlist(.Full): return UIImage(asset: .Ic_heart_full_black)
        case Settings(.Full): return UIImage(asset: .Ic_profile_full_black)
            
        case Dashboard(.Line): return UIImage(asset: .Ic_hanger_line_black)
        case Search(.Line): return UIImage(asset: .Ic_glass_line_black)
        case Basket(.Line): return UIImage(asset: .Ic_cart_line_black)
        case Wishlist(.Line): return UIImage(asset: .Ic_heart_line_black)
        case Settings(.Line): return UIImage(asset: .Ic_profile_line_black)
        }
    }
}

enum TabBarIconVersion {
    case Full, Line
    mutating func toggle() { self = (self == Full) ? Line : Full }
}

extension UITabBarItem {
    convenience init(tabBarIcon: TabBarIcon, badgeValue: Int? = nil) {
        self.init(title: nil, image: tabBarIcon.image, selectedImage: nil)
    }
}