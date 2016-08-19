import Foundation
import UIKit

extension NSURL {
    static func createImageUrl(url: String, width: Int? = nil, height: Int? = nil) -> NSURL {
        var url = NSURL(string: url)!
        
        if let width = width {
            url = url.URLByAppendingParams(["w": String(width)])
        }
        if let height = height {
            url = url.URLByAppendingParams(["h": String(height)])
        }
        return url
    }
}
