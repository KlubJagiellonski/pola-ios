import Foundation
import UIKit

extension NSURL {
    static func createImageUrl(url: String, w: CGFloat? = nil, h: CGFloat? = nil) -> NSURL {
        var url = NSURL(string: url)!
        
        let scale = UIScreen.mainScreen().scale
        if let width = w {
            url = url.URLByAppendingParams(["w": String(Int(width * scale))])
        }
        if let height = h {
            url = url.URLByAppendingParams(["h": String(Int(height * scale))])
        }
        return url
    }
}
