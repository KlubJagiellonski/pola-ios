import Foundation
import UIKit
import Haneke

extension UIImageView {
    func loadImageFromUrl(url: String, size: CGSize? = nil) {
        // TODO: - add possibility to change between jpeg/webp urls
        var url = NSURL(string: url)!
        if let s = size {
            url = url.URLByAppendingParams(["w": String(s.width), "h": String(s.height)])
        }
        hnk_setImageFromURL(url, format: Format<UIImage>(name: "original"))
    }
}