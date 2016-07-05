import Foundation
import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont, numberOfLines: Int = 0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        if numberOfLines == 0 {
            return boundingBox.height
        }
        
        return min(boundingBox.height, CGFloat(numberOfLines) * font.lineHeight)
    }
    
    var strikethroughString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
    }
    
    func stringWithHighlightedSubsttring(substring: String) -> NSMutableAttributedString {
        let string = self as NSString
        let range = string.rangeOfString(substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(named: .Blue), range: range)
        return attributedString
    }
    
}