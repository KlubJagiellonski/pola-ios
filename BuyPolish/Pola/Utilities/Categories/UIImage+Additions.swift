import UIKit

extension UIImage {
    @objc
    class func image(color: UIColor) ->  UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    @objc
    func scaled(toWidth width: CGFloat) -> UIImage {
        let scaleFactor = width / size.width
        let newSize = CGSize(width: width, height: size.height * scaleFactor)
        
        return scaled(toSize: newSize)
    }
    
    @objc
    func scaled(toHeight height: CGFloat) -> UIImage {
        let scaleFactor = height / size.height
        let newSize = CGSize(width: size.width * scaleFactor, height: height)
        
        return scaled(toSize: newSize)
    }
    
    func scaled(toSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: .zero, size: newSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc
    var widthInPixels: CGFloat {
        size.width * scale
    }
    
    @objc
     var heightInPixels: CGFloat {
         size.height * scale
     }

}
