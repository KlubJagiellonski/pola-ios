import Foundation
import Decodable

struct PromoSlideshow {
    let id: ObjectId
    let video: PromoSlideshowVideo
    let playlist: [PromoSlideshowPlaylistItem]
    let links: [PromoSlideshowLink]
}

struct PromoSlideshowVideo {
    let steps: [PromoSlideshowVideoStep]
}

enum PromoSlideshowVideoStepType: String {
    case Video = "video"
    case Image = "image"
    case Product = "product"
}

struct PromoSlideshowVideoStep {
    let type: PromoSlideshowVideoStepType
    let link: String?
    let duration: Int
    let annotations: [PromoSlideshowVideoAnnotation]
    let product: PromoSlideshowProduct?
}

struct PromoSlideshowPlaylistItem {
    let id: ObjectId
    let imageUrl: String
    let caption: PromoSlideshowPlaylistItemCaption
}

struct PromoSlideshowLink {
    let text: String
    let link: String
}

struct PromoSlideshowPlaylistItemCaption {
    let title: String
    let subtitle: String
    let color: PromoSlideshowPlaylistItemCaptionColor
}

enum PromoSlideshowPlaylistItemCaptionColor: String {
    case White = "white"
    case Black = "black"
}

struct PromoSlideshowVideoAnnotation {
    let style: PromoSlideshowVideoAnnotationStyle
    let text: String
    let verticalPosition: Double
    let startTime: Int
    let duration: Int
}

enum PromoSlideshowVideoAnnotationStyle: String {
    case White = "white"
    case Black = "black"
}

struct PromoSlideshowProduct {
    let id: ObjectId
    let brand: Brand
    let name: String
    let basePrice: Money
    let price: Money
    let imageUrl: String
}

// MARK:- Utils

extension PromoSlideshowVideo {
    var duration: Int {
        return steps.reduce(0) { $0 + $1.duration }
    }
}

// MARK:- Decodable, Encodable

extension PromoSlideshow: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshow {
        return try PromoSlideshow(
            id: json => "id",
            video: json => "data" => "video",
            playlist: json => "data" => "video_playlist",
            links: json => "data" => "links"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "id": id,
            "data": [
                "video": video.encode(),
                "video_playlist": playlist.map { $0.encode() } as NSArray,
                "links": links.map { $0.encode() } as NSArray
            ] as NSDictionary
        ] as NSDictionary
    }
}

extension PromoSlideshowVideo: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowVideo {
        return try PromoSlideshowVideo(
            steps: json => "steps"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "steps": steps.map { $0.encode() } as NSArray
        ] as NSDictionary
    }
}

extension PromoSlideshowVideoStep: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowVideoStep {
        let annotations: [PromoSlideshowVideoAnnotation] = (try json =>? "annotations") ?? []
        return try PromoSlideshowVideoStep(
            type: json => "type",
            link: json =>? "link",
            duration: json => "duration",
            annotations: annotations,
            product: json =>? "product"
        )
    }
    
    func encode() -> AnyObject {
        let dict = [
            "type": type.rawValue,
            "duration": duration,
            "annotations": annotations.map { $0.encode() } as NSArray
        ] as NSMutableDictionary
        if link != nil { dict.setObject(link!, forKey: "link") }
        if product != nil { dict.setObject(product!.encode(), forKey: "product") }
        return dict
    }
}

extension PromoSlideshowVideoStepType: Decodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowVideoStepType {
        return PromoSlideshowVideoStepType(rawValue: json as! String)!
    }
}

extension PromoSlideshowProduct: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowProduct {
        return try PromoSlideshowProduct(
            id: json => "id",
            brand: json => "store",
            name: json => "name",
            basePrice: json => "msrp",
            price: json => "price",
            imageUrl: json => "images" => "default" => "url"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "id": id,
            "store": brand.encode(),
            "name": name,
            "msrp": basePrice.amount,
            "price": price.amount,
            "images": [
                "default": [
                    "url": imageUrl
                ] as NSDictionary
            ] as NSDictionary
        ] as NSDictionary
    }
}

extension PromoSlideshowVideoAnnotation: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowVideoAnnotation {
        return try PromoSlideshowVideoAnnotation(
            style: json => "style",
            text: json => "text",
            verticalPosition: json => "vertical_position",
            startTime: json => "start_time",
            duration: json => "duration"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "style": style.rawValue,
            "text": text,
            "vertical_position": verticalPosition,
            "start_time": startTime,
            "duration": duration
        ] as NSDictionary
    }
}

extension PromoSlideshowVideoAnnotationStyle: Decodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowVideoAnnotationStyle {
        return PromoSlideshowVideoAnnotationStyle(rawValue: json as! String)!
    }
}

extension PromoSlideshowPlaylistItem: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowPlaylistItem {
        return try PromoSlideshowPlaylistItem(
            id: json => "id",
            imageUrl: json => "image_link",
            caption: json => "caption"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "id": id,
            "image_link": imageUrl,
            "caption": caption.encode()
        ] as NSDictionary
    }
}

extension PromoSlideshowPlaylistItemCaption: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowPlaylistItemCaption {
        return try PromoSlideshowPlaylistItemCaption(
            title: json => "title",
            subtitle: json => "subtitle",
            color: json => "color"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "title": title,
            "subtitle": subtitle,
            "color": color.rawValue
        ] as NSDictionary
    }
}

extension PromoSlideshowPlaylistItemCaptionColor: Decodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowPlaylistItemCaptionColor {
        return PromoSlideshowPlaylistItemCaptionColor(rawValue: json as! String)!
    }
}

extension PromoSlideshowLink: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> PromoSlideshowLink {
        return try PromoSlideshowLink(
            text: json => "text",
            link: json => "link"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "text": text,
            "link": link
        ] as NSDictionary
    }
}

// MARK:- Equatable

extension PromoSlideshow: Equatable {}
extension PromoSlideshowVideo: Equatable {}
extension PromoSlideshowVideoStepType: Equatable {}
extension PromoSlideshowVideoStep: Equatable {}
extension PromoSlideshowPlaylistItem: Equatable {}
extension PromoSlideshowLink: Equatable {}
extension PromoSlideshowPlaylistItemCaption: Equatable {}
extension PromoSlideshowPlaylistItemCaptionColor: Equatable {}
extension PromoSlideshowVideoAnnotation: Equatable {}
extension PromoSlideshowVideoAnnotationStyle: Equatable {}
extension PromoSlideshowProduct: Equatable {}

func ==(lhs: PromoSlideshow, rhs: PromoSlideshow) -> Bool {
    return lhs.id == rhs.id && lhs.links == rhs.links && lhs.playlist == rhs.playlist && lhs.video == rhs.video
}

func ==(lhs: PromoSlideshowVideo, rhs: PromoSlideshowVideo) -> Bool {
    return lhs.duration == rhs.duration && lhs.steps == rhs.steps
}

func ==(lhs: PromoSlideshowVideoStepType, rhs: PromoSlideshowVideoStepType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

func ==(lhs: PromoSlideshowVideoStep, rhs: PromoSlideshowVideoStep) -> Bool {
    return lhs.annotations == rhs.annotations && lhs.duration == rhs.duration && lhs.link == rhs.link && lhs.product == rhs.product && lhs.type == rhs.type
}

func ==(lhs: PromoSlideshowPlaylistItem, rhs: PromoSlideshowPlaylistItem) -> Bool {
    return lhs.caption == rhs.caption && lhs.id == rhs.id && lhs.imageUrl == rhs.imageUrl
}

func ==(lhs: PromoSlideshowLink, rhs: PromoSlideshowLink) -> Bool {
    return lhs.link == rhs.link && lhs.text == rhs.text
}

func ==(lhs: PromoSlideshowPlaylistItemCaption, rhs: PromoSlideshowPlaylistItemCaption) -> Bool {
    return lhs.color == rhs.color && lhs.subtitle == rhs.subtitle && lhs.title == rhs.title
}

func ==(lhs: PromoSlideshowPlaylistItemCaptionColor, rhs: PromoSlideshowPlaylistItemCaptionColor) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

func ==(lhs: PromoSlideshowVideoAnnotation, rhs: PromoSlideshowVideoAnnotation) -> Bool {
    return lhs.duration == rhs.duration && lhs.startTime == rhs.startTime && lhs.style == rhs.style && lhs.text == rhs.text && lhs.verticalPosition == rhs.verticalPosition
}

func ==(lhs: PromoSlideshowVideoAnnotationStyle, rhs: PromoSlideshowVideoAnnotationStyle) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

func ==(lhs: PromoSlideshowProduct, rhs: PromoSlideshowProduct) -> Bool {
    return lhs.basePrice == rhs.basePrice && lhs.brand == rhs.brand && lhs.id == rhs.id && lhs.imageUrl == rhs.imageUrl && lhs.name == rhs.name && lhs.price == rhs.price
}