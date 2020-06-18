import UIKit

extension UIView {
    var topSafeAreaInset: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.top
        } else {
            return UIApplication.statusBarHeight
        }
    }

    var frameOrigin: CGPoint {
        get {
            frame.origin
        }
        set {
            frame = CGRect(origin: newValue, size: frame.size)
        }
    }

    var frameSize: CGSize {
        get {
            frame.size
        }
        set {
            frame = CGRect(origin: frame.origin, size: newValue)
        }
    }
}
