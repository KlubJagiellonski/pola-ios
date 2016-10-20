import Foundation
import Decodable

struct WebContent {
    let title: String
    let content: String
}

// MARK:- Decodable

extension WebContent: Decodable {
    static func decode(json: AnyObject) throws -> WebContent {
        return try WebContent(
            title: json => "title",
            content: json => "content"
        )
    }
}