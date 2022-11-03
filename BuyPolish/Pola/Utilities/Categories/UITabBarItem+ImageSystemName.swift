import UIKit

extension UITabBarItem {
    convenience init(title: String, imageSystemName: String) {
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: imageSystemName)
        } else {
            image = nil
        }
        self.init(title: title, image: image, selectedImage: nil)
    }
}
