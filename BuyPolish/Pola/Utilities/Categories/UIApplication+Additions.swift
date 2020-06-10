import UIKit

extension UIApplication {
    class var statusBarHeight: CGFloat {
        let size = UIApplication.shared.statusBarFrame.size
        return min(size.width, size.height)
    }
}
