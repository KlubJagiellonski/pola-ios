import UIKit

extension UIImage {
    class func image(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    func scaled(toWidth width: CGFloat) -> UIImage {
        let scaleFactor = width / size.width
        let newSize = CGSize(width: width, height: size.height * scaleFactor)

        return scaled(toSize: newSize)
    }

    func scaled(toHeight height: CGFloat) -> UIImage {
        let scaleFactor = height / size.height
        let newSize = CGSize(width: size.width * scaleFactor, height: height)

        return scaled(toSize: newSize)
    }

    func scaled(toMaxSide maxSide: CGFloat) -> UIImage {
        if size.height > size.width {
            return scaled(toHeight: maxSide)
        } else {
            return scaled(toWidth: maxSide)
        }
    }

    func scaled(toSize newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    var sizeInPixels: CGSize {
        CGSize(width: widthInPixels, height: heightInPixels)
    }

    var widthInPixels: CGFloat {
        size.width * scale
    }

    var heightInPixels: CGFloat {
        size.height * scale
    }
}
