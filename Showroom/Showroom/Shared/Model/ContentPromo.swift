import Foundation
import Decodable

struct ContentPromo: Equatable {
    let image: ContentPromoImage
}

enum ContentPromoTextType: String {
    case White = "white"
    case Black = "black"
}

struct ContentPromoImage: Equatable {
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
        let color: String? = try j =>? "color"
        return try ContentPromoImage(
            url: j => "url",
            title: j =>? "title",
            subtitle: j =>? "subtitle",
            color: color != nil ? ContentPromoTextType(rawValue: color!) : nil
        )
    }
}

// MARK: - Encodable
extension ContentPromo: Encodable {
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "image": image.encode()
        ]
        return dict
    }
}

extension ContentPromoImage: Encodable {
    func encode() -> AnyObject {
        let imageDict: NSMutableDictionary = [
            "url": url
        ]
        if title != nil { imageDict.setObject(title!, forKey: "title") }
        if subtitle != nil { imageDict.setObject(subtitle!, forKey: "subtitle") }
        if color != nil { imageDict.setObject(color!.rawValue, forKey: "color") }
        return imageDict
    }
}

// MARK: - Equatable
func ==(lhs: ContentPromo, rhs: ContentPromo) -> Bool
{
    return lhs.image == rhs.image
}

func ==(lhs: ContentPromoImage, rhs: ContentPromoImage) -> Bool
{
    return lhs.url == rhs.url && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.color?.rawValue == rhs.color?.rawValue
}
