import Foundation
import Decodable

struct ContentPromoResult {
    let contentPromos: [ContentPromo]
}

struct ContentPromo {
    let image: ContentPromoImage
    let caption: ContentPromoCaption?
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

struct ContentPromoCaption {
    let title: String
    let subtitle: String
}

// MARK: - Decodable
extension ContentPromoResult: Decodable {
    static func decode(json: AnyObject) throws -> ContentPromoResult {
        let array = json as! [AnyObject]
        return ContentPromoResult(contentPromos: try array.map(ContentPromo.decode))
    }
}

extension ContentPromo: Decodable {
    static func decode(j: AnyObject) throws -> ContentPromo {
        return try ContentPromo(
            image: j => "image",
            caption: j =>? "caption"
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

extension ContentPromoCaption: Decodable {
    static func decode(j: AnyObject) throws -> ContentPromoCaption {
        return try ContentPromoCaption(
            title: j => "title",
            subtitle: j => "subtitle"
        )
    }
}

// MARK: - Encodable
extension ContentPromoResult: Encodable {
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for contentPromo in contentPromos {
            encodedList.addObject(contentPromo.encode())
        }
        return encodedList
    }
}

extension ContentPromo: Encodable {
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "image": image.encode()
        ]
        if caption != nil { dict.setObject(caption!.encode(), forKey: "caption") }
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

extension ContentPromoCaption: Encodable {
    func encode() -> AnyObject {
        let imageDict: NSMutableDictionary = [
            "title": title,
            "subtitle": subtitle
        ]
        return imageDict
    }
}

// MARK: - Equatable
extension ContentPromoResult: Equatable {}
extension ContentPromoImage: Equatable {}
extension ContentPromo: Equatable {}
extension ContentPromoCaption: Equatable {}

func ==(lhs: ContentPromoResult, rhs: ContentPromoResult) -> Bool
{
    return lhs.contentPromos == rhs.contentPromos
}

func ==(lhs: ContentPromo, rhs: ContentPromo) -> Bool
{
    return lhs.image == rhs.image && lhs.caption == rhs.caption
}

func ==(lhs: ContentPromoImage, rhs: ContentPromoImage) -> Bool
{
    return lhs.url == rhs.url && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.color?.rawValue == rhs.color?.rawValue
}

func ==(lhs: ContentPromoCaption, rhs: ContentPromoCaption) -> Bool
{
    return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
}
