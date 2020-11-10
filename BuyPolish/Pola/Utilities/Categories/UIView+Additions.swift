import UIKit

extension UIView {
    var topSafeAreaInset: CGFloat {
        return safeAreaInsets.top
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
