import Foundation
import UIKit
import Haneke

extension UIImageView {
    func loadImageFromUrl(url: String, size: CGSize? = nil) {
        // TODO: - add possibility to change between jpeg/webp urls
        var url = NSURL(string: url)!
        if let s = size {
            let scale = UIScreen.mainScreen().scale
            url = url.URLByAppendingParams(["w": String(Int(s.width * scale)), "h": String(Int(s.height * scale))])
        }
        hnk_setImageFromURL(url, format: Format<UIImage>(name: "original"))
    }
}