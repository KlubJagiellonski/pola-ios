// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit.UIImage

enum Asset: String {
  case Ic_close = "ic_close"
  case Ic_do_ulubionych = "ic_do_ulubionych"
  case Ic_dropdown = "ic_dropdown"
  case Ic_dropdown_small = "ic_dropdown_small"
  case Ic_glowna = "ic_glowna"
  case Ic_glowna_blue = "ic_glowna_blue"
  case Ic_info = "ic_info"
  case Ic_koszyk = "ic_koszyk"
  case Ic_koszyk_blue = "ic_koszyk_blue"
  case Ic_profil = "ic_profil"
  case Ic_profil_blue = "ic_profil_blue"
  case Ic_przegladaj = "ic_przegladaj"
  case Ic_przegladaj_blue = "ic_przegladaj_blue"
  case Ic_share = "ic_share"
  case Ic_ulubione = "ic_ulubione"
  case Ic_ulubione_blue = "ic_ulubione_blue"

  var image: UIImage {
    return UIImage(asset: self)
  }
}

extension UIImage {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

