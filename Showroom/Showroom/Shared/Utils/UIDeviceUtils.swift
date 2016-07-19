import UIKit

public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .Phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.mainScreen().nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920, 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
}
