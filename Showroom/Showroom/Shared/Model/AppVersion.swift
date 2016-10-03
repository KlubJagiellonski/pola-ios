import Foundation
import Decodable

struct AppVersion {
    let version: String
    let promoImageUrl: String?
}

// MARK:- Decodable

extension AppVersion: Decodable {
    static func decode(json: AnyObject) throws -> AppVersion {
        var imageUrl: String? = try json =>? "imageUrl"
        if imageUrl == "" {
            imageUrl = nil
        }
        return try AppVersion(version: json => "appVersion", promoImageUrl: imageUrl)
    }
}