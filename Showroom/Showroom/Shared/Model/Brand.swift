import Foundation
import Decodable

struct BrandDetails {
    let id: ObjectId
    let name: String
    let imageUrl: String
    let description: String
    let videos: [BrandVideo]
    var lowResImageUrl: String?
}

struct Brand {
    let id: ObjectId
    let name: String
}

enum BrandVideoTitleStyle: String {
    case White = "white"
    case Black = "black"
}

struct BrandVideo {
    let id: ObjectId
    let imageUrl: String
    let title: String
    let color: BrandVideoTitleStyle
}

extension BrandDetails {
    func appendLowResImageUrl(url: String?) -> BrandDetails{
        return BrandDetails(id: id, name: name, imageUrl: imageUrl, description: description, videos: [], lowResImageUrl: url)
    }
}

// MARK: - Decodable, Encodable

extension BrandDetails: Decodable {
    static func decode(json: AnyObject) throws -> BrandDetails {
        //TODO: - remove in future
        let videos = try BrandDetails.mockVideos(json)
        return try BrandDetails(
            id: json => "id",
            name: json => "name",
            imageUrl: json => "image_url",
            description: json => "description",
            videos: videos,
            lowResImageUrl: nil
        )
    }
    
    static func mockVideos(json: AnyObject) throws -> [BrandVideo] {
        let type = NSUserDefaults.standardUserDefaults().integerForKey("video_brand_mock")
        switch type {
        case 1:
            return [
                BrandVideo(id: 2, imageUrl: "https://storage.shwrm.net/prod/video/risk/gfx/intro_empty.jpg", title: "Wyjaśniam jak ubieram polskie sławne aktorki", color: .Black)
            ]
        case 2:
            return [
                BrandVideo(id: 2, imageUrl: "https://storage.shwrm.net/prod/video/risk/gfx/intro_empty.jpg", title: "Wyjaśniam jak ubieram polskie sławne aktorki", color: .Black),
                BrandVideo(id: 3, imageUrl: "https://storage.shwrm.net/prod/video/risk/gfx/p2_biala_jolka.jpg", title: "Czyszczenie szafy z nadmiaru Twoich ubrań", color: .White),
                BrandVideo(id: 4, imageUrl: "https://storage.shwrm.net/prod/video/risk/gfx/p3_wieczorowa_suknia.jpg", title: "Nie zawsze wiadomo co zrobić ze swoimi ubraniami", color: .White)
            ]
        default:
            return (try json =>? "videos") ?? []
        }
    }
}

extension Brand: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> Brand {
        return try Brand(
            id: j => "id",
            name: j => "name"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name
        ]
        return dict
    }
}

extension BrandVideoTitleStyle: Decodable {
    static func decode(json: AnyObject) throws -> BrandVideoTitleStyle {
        return BrandVideoTitleStyle(rawValue: json as! String)!
    }
}

extension BrandVideo: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> BrandVideo {
        return try BrandVideo(
            id: json => "id",
            imageUrl: json => "imageUrl",
            title: json => "title",
            color: json => "color"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "id": id,
            "imageUrl": imageUrl,
            "title": title,
            "color": color.rawValue
        ] as NSDictionary
    }
}

// MARK: - Equatable

extension Brand: Equatable {}

func ==(lhs: Brand, rhs: Brand) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
