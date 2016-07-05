import UIKit

class ExtendedLabel: UILabel {
    var textPadding: UIEdgeInsets?
    
    override func drawTextInRect(rect: CGRect) {
        if let textPadding = textPadding {
            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, textPadding))
        } else {
            super.drawTextInRect(rect)
        }
    }
}