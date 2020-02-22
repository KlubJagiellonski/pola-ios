import UIKit

class ExtendedButton: UIButton {
    
    var extendedTouchSize = CGFloat.zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -extendedTouchSize, dy: -extendedTouchSize).contains(point)
    }
    
}
