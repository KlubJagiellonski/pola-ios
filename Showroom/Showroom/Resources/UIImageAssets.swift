// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit.UIImage

enum Asset: String {
  case Empty_bag = "empty_bag"
  case Error = "error"
  case For_her = "for_her"
  case For_him = "for_him"
  case Ic_back = "ic_back"
  case Ic_bag = "ic_bag"
  case Ic_bag_selected = "ic_bag_selected"
  case Ic_browse = "ic_browse"
  case Ic_browse_selected = "ic_browse_selected"
  case Ic_checkbox_off = "ic_checkbox_off"
  case Ic_checkbox_on = "ic_checkbox_on"
  case Ic_chevron_down = "ic_chevron_down"
  case Ic_chevron_right = "ic_chevron_right"
  case Ic_close = "ic_close"
  case Ic_close_toast = "ic_close_toast"
  case Ic_cross_red = "ic_cross_red"
  case Ic_do_ulubionych = "ic_do_ulubionych"
  case Ic_dropdown = "ic_dropdown"
  case Ic_dropdown_small = "ic_dropdown_small"
  case Ic_facebook = "ic_facebook"
  case Ic_favorites = "ic_favorites"
  case Ic_favorites_selected = "ic_favorites_selected"
  case Ic_fb = "ic_fb"
  case Ic_filter = "ic_filter"
  case Ic_home = "ic_home"
  case Ic_home_selected = "ic_home_selected"
  case Ic_info = "ic_info"
  case Ic_instagram = "ic_instagram"
  case Ic_settings = "ic_settings"
  case Ic_settings_selected = "ic_settings_selected"
  case Ic_share = "ic_share"
  case Ic_tick = "ic_tick"
  case Ic_w_ulubionych = "ic_w_ulubionych"
  case Img_wieszak = "img_wieszak"
  case Logo = "logo"
  case Profile_header = "profile_header"
  case Profile_logo = "profile_logo"
  case Refresh = "refresh"
  case SplashImage4s = "SplashImage4s"
  case SplashImage5s = "SplashImage5s"
  case SplashImage6 = "SplashImage6"
  case SplashImage6p = "SplashImage6p"
  case Temp_trend = "temp_trend"

  var image: UIImage {
    return UIImage(asset: self)
  }
}

extension UIImage {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

