// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit.UIColor

extension UIColor {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

enum ColorName {
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bb1270"></span>
  /// Alpha: 100% <br/> (0xbb1270ff)
  case Badge
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
  /// Alpha: 100% <br/> (0x000000ff)
  case Black
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1e1cbf"></span>
  /// Alpha: 100% <br/> (0x1e1cbfff)
  case Blue
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#a4aab3"></span>
  /// Alpha: 100% <br/> (0xa4aab3ff)
  case DarkGray
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#a3aab2"></span>
  /// Alpha: 100% <br/> (0xa3aab2ff)
  case Dim
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#edeef0"></span>
  /// Alpha: 100% <br/> (0xedeef0ff)
  case Gray
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#979797"></span>
  /// Alpha: 100% <br/> (0x979797ff)
  case Manatee
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#767676"></span>
  /// Alpha: 100% <br/> (0x767676ff)
  case OldLavender
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f4fa"></span>
  /// Alpha: 100% <br/> (0xf2f4faff)
  case ProductPageBackground
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bb1270"></span>
  /// Alpha: 100% <br/> (0xbb1270ff)
  case RedViolet
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dddddd"></span>
  /// Alpha: 100% <br/> (0xddddddff)
  case Separator
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fafafa"></span>
  /// Alpha: 100% <br/> (0xfafafaff)
  case Snow
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  case White

  var rgbaValue: UInt32! {
    switch self {
    case .Badge: return 0xbb1270ff
    case .Black: return 0x000000ff
    case .Blue: return 0x1e1cbfff
    case .DarkGray: return 0xa4aab3ff
    case .Dim: return 0xa3aab2ff
    case .Gray: return 0xedeef0ff
    case .Manatee: return 0x979797ff
    case .OldLavender: return 0x767676ff
    case .ProductPageBackground: return 0xf2f4faff
    case .RedViolet: return 0xbb1270ff
    case .Separator: return 0xddddddff
    case .Snow: return 0xfafafaff
    case .White: return 0xffffffff
    }
  }

  var color: UIColor {
    return UIColor(named: self)
  }
}

extension UIColor {
  convenience init(named name: ColorName) {
    self.init(rgbaValue: name.rgbaValue)
  }
}

