// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit.UIImage

enum Asset: String {
  case Ic_back = "ic_back"
  case Ic_bag_full_black = "ic_bag_full_black"
  case Ic_bag_full_blue = "ic_bag_full_blue"
  case Ic_cart_line_black = "ic_cart_line_black"
  case Ic_cart_line_blue = "ic_cart_line_blue"
  case Ic_chevron_down = "ic_chevron_down"
  case Ic_chevron_right = "ic_chevron_right"
  case Ic_close = "ic_close"
  case Ic_do_ulubionych = "ic_do_ulubionych"
  case Ic_dropdown = "ic_dropdown"
  case Ic_dropdown_small = "ic_dropdown_small"
  case Ic_glass_line_black = "ic_glass_line_black"
  case Ic_glass_line_blue = "ic_glass_line_blue"
  case Ic_hanger_line_black = "ic_hanger_line_black"
  case Ic_hanger_line_blue = "ic_hanger_line_blue"
  case Ic_heart_full_black = "ic_heart_full_black"
  case Ic_heart_full_blue = "ic_heart_full_blue"
  case Ic_heart_line_black = "ic_heart_line_black"
  case Ic_heart_line_blue = "ic_heart_line_blue"
  case Ic_home_full_black = "ic_home_full_black"
  case Ic_home_full_blue = "ic_home_full_blue"
  case Ic_info = "ic_info"
  case Ic_profile_full_black = "ic_profile_full_black"
  case Ic_profile_full_blue = "ic_profile_full_blue"
  case Ic_profile_line_black = "ic_profile_line_black"
  case Ic_profile_line_blue = "ic_profile_line_blue"
  case Ic_przegladaj = "ic_przegladaj"
  case Ic_przegladaj_blue = "ic_przegladaj_blue"
  case Ic_share = "ic_share"
  case Ic_tick = "ic_tick"
  case Ic_w_ulubionych = "ic_w_ulubionych"

  var image: UIImage {
    return UIImage(asset: self)
  }
}

extension UIImage {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

