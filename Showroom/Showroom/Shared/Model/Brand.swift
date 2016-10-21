import Foundation
import Decodable

struct BrandDetails {
    let id: ObjectId
    let name: String
    let imageUrl: String
    let description: String
    var lowResImageUrl: String?
}

struct Brand {
    let id: ObjectId
    let name: String
}

extension BrandDetails {
    func appendLowResImageUrl(url: String?) -> BrandDetails{
        return BrandDetails(id: id, name: name, imageUrl: imageUrl, description: description, lowResImageUrl: url)
    }
}

// MARK: - Decodable, Encodable

extension BrandDetails: Decodable {
    static func decode(json: AnyObject) throws -> BrandDetails {
        return try BrandDetails(
            id: json => "id",
            name: json => "name",
            imageUrl: json => "image_url",
            description: json => "description",
            lowResImageUrl: nil
        )
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

// MARK: - Equatable

extension Brand: Equatable {}

func ==(lhs: Brand, rhs: Brand) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}