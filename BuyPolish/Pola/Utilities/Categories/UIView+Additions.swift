import UIKit

extension UIView {
    @objc
    var topSafeAreaInset: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.top
        } else {
            return UIApplication.statusBarHeight
        }
    }
}
