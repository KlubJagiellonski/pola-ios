import Foundation
import UIKit

extension UIImage {
    static func fromColor(color: UIColor, size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func round(withCornerRadius cornerRadius: Int) -> UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: CGFloat(cornerRadius)
            ).addClip()
        drawInRect(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

