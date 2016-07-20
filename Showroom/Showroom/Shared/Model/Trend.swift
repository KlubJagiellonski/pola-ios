import Foundation
import Decodable

struct EntryTrendInfo {
    let slug: String
    let name: String?
}

struct TrendInfo {
    let name: String
    let description: String
    let imageUrl: String
}

// MARK: - Decodable, Encodable

extension TrendInfo: Decodable {
    static func decode(json: AnyObject) throws -> TrendInfo {
        return try TrendInfo(
            name: json => "name",
            description: json => "description",
            imageUrl: json => "imageUrl"
        )
    }
}
