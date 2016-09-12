import Foundation
import Decodable

struct AppVersion {
    let  version: String
}

// MARK:- Decodable

extension AppVersion: Decodable {
    static func decode(json: AnyObject) throws -> AppVersion {
        return try AppVersion(version: json => "appVersion")
    }
}