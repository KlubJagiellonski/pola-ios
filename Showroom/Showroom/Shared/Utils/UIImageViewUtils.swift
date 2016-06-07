import Foundation
import UIKit
import Haneke

extension UIImageView {
    func loadImageFromUrl(url: String, w: CGFloat? = nil, h: CGFloat? = nil) {
        // TODO: - add possibility to change between jpeg/webp urls
        var url = NSURL(string: url)!
        let scale = UIScreen.mainScreen().scale
        if let width = w {
            url = url.URLByAppendingParams(["w": String(Int(width * scale))])
        }
        if let height = h {
            url = url.URLByAppendingParams(["h": String(Int(height * scale))])
        }
        hnk_setImageFromURL(url, format: Format<UIImage>(name: "original"))
    }
}