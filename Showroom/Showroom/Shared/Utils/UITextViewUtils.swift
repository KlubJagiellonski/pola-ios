import Foundation
import UIKit

extension UITextView {
    func applyPlainStyle() {
        self.font = UIFont(fontType: .InputLarge)
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1;
    }
    
    //we should use UITextVIew for markdown because there is no possibility to change link color & underline for UILabel
    func applyMarkdownStyle(maxNumberOfLines maxNumberOfLines: Int = 0) {
        textContainer.maximumNumberOfLines = maxNumberOfLines
        textContainer.lineBreakMode = .ByTruncatingTail
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsetsZero
        backgroundColor = UIColor.clearColor()
        linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Black),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue
        ]
        editable = false
        scrollEnabled = false
        userInteractionEnabled = false
    }
}
