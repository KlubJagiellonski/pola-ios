import Foundation
import Decodable

struct EntryTrendInfo {
    let slug: String
    let name: String?
    let link: NSURL?
}

struct TrendInfo {
    let name: String
    let description: String
    let imageInfo: TrendImageInfo
}

struct TrendImageInfo {
    let width: Int
    let height: Int
    let url: String
}

// MARK: - Decodable, Encodable

extension TrendInfo: Decodable {
    static func decode(json: AnyObject) throws -> TrendInfo {
        return try TrendInfo(
            name: json => "name",
            description: json => "description",
            imageInfo: json => "image"
        )
    }
}

extension TrendImageInfo: Decodable {
    static func decode(json: AnyObject) throws -> TrendImageInfo {
        return try TrendImageInfo(
            width: json => "width",
            height: json => "height",
            url: json => "url"
        )
    }
}
