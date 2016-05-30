import Foundation
import Decodable

struct ContentPromo {
    let image: ContentPromoImage
}

enum ContentPromoTextType: String {
    case White = "white"
    case Black = "black"
}

struct ContentPromoImage {
    let url: String
    let title: String?
    let subtitle: String?
    let color: ContentPromoTextType?
}

// MARK: - Decodable
extension ContentPromo: Decodable {
    static func decode(j: AnyObject) throws -> ContentPromo {
        return try ContentPromo(
            image: ContentPromoImage.decode(j => "image")
        )
    }
}

extension ContentPromoImage: Decodable {
    static func decode(j: AnyObject) throws -> ContentPromoImage {
        let color:String? = try j =>? "color"
        return try ContentPromoImage(
            url: j => "url",
            title: j =>? "title",
            subtitle: j =>? "subtitle",
            color: color != nil ? ContentPromoTextType(rawValue: color!) : nil
        )
    }
}