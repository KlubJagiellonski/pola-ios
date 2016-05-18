import Foundation
import UIKit
import Haneke

extension UIImageView {
    func loadImageFromUrl(url: String) {
        // TODO: - add possibility to change between jpeg/webp urls
        hnk_setImageFromURL(NSURL(string: url)!)
    }
}