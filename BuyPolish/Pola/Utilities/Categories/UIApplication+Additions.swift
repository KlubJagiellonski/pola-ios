import UIKit

extension UIApplication {
    
    @objc
    class var statusBarHeight: CGFloat {
        let size = UIApplication.shared.statusBarFrame.size
        return min(size.width, size.height)
    }
}
