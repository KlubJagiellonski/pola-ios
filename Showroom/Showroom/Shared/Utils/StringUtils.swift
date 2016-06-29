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
    
    func createStrikethroughString(color: UIColor) -> NSMutableAttributedString {
        let attributes: [String: AnyObject] = [
            NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSStrikethroughColorAttributeName: color
        ]
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
}