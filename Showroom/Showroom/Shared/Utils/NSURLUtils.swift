import Foundation
import UIKit

extension NSURL {
    static func createImageUrl(url: String, width: CGFloat? = nil, height: CGFloat? = nil, scale: CGFloat = UIScreen.mainScreen().scale) -> NSURL {
        var url = NSURL(string: url)!
        
        if let width = width {
            url = url.URLByAppendingParams(["w": String(Int(width * scale))])
        }
        if let height = height {
            url = url.URLByAppendingParams(["h": String(Int(height * scale))])
        }
        return url
    }
}
