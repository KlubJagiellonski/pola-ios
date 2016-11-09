import Foundation
import Decodable

struct ContentPromoResult {
    let contentPromos: [ContentPromo]
}

struct ContentPromo {
    let image: ContentPromoImage
    let caption: ContentPromoCaption?
    let link: String
    let showPlayOverlay: Bool
}

enum ContentPromoTextType: String {
    case White = "white"
    case Black = "black"
}

struct ContentPromoImage {
    let url: String
    let width: Int
    let height: Int
    let title: String?
    let subtitle: String?
    let color: ContentPromoTextType?
}

struct ContentPromoCaption {
    let title: String
    let subtitle: String
}

// MARK: - Decodable
extension ContentPromoResult: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> ContentPromoResult {
        let array = json as! [AnyObject]
        return ContentPromoResult(contentPromos: try array.map(ContentPromo.decode))
    }
    
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for contentPromo in contentPromos {
            encodedList.addObject(contentPromo.encode())
        }
        return encodedList
    }
}

extension ContentPromo: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ContentPromo {
        let showPlayOverlay: Bool = (try j =>? "show_play_overlay") ?? false
        return try ContentPromo(
            image: j => "image",
            caption: j =>? "caption",
            link: j => "link",
            showPlayOverlay: showPlayOverlay
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "image": image.encode(),
            "link": link,
            "show_play_overlay": showPlayOverlay
        ]
        if caption != nil { dict.setObject(caption!.encode(), forKey: "caption") }
        return dict
    }
}

extension ContentPromoImage: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ContentPromoImage {
        let color: String? = try j =>? "color"
        return try ContentPromoImage(
            url: j => "url",
            width: j => "width",
            height: j => "height",
            title: j =>? "title",
            subtitle: j =>? "subtitle",
            color: color != nil ? ContentPromoTextType(rawValue: color!) : nil
        )
    }
    
    func encode() -> AnyObject {
        let imageDict: NSMutableDictionary = [
            "url": url,
            "width": width,
            "height": height
        ]
        if title != nil { imageDict.setObject(title!, forKey: "title") }
        if subtitle != nil { imageDict.setObject(subtitle!, forKey: "subtitle") }
        if color != nil { imageDict.setObject(color!.rawValue, forKey: "color") }
        return imageDict
    }
}

extension ContentPromoCaption: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ContentPromoCaption {
        return try ContentPromoCaption(
            title: j => "title",
            subtitle: j => "subtitle"
        )
    }
    
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
    return lhs.image == rhs.image && lhs.caption == rhs.caption && lhs.link == rhs.link && lhs.showPlayOverlay == rhs.showPlayOverlay
}

func ==(lhs: ContentPromoImage, rhs: ContentPromoImage) -> Bool
{
    return lhs.url == rhs.url && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.color?.rawValue == rhs.color?.rawValue && lhs.width == rhs.width && lhs.height == rhs.height
}

func ==(lhs: ContentPromoCaption, rhs: ContentPromoCaption) -> Bool
{
    return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
}
