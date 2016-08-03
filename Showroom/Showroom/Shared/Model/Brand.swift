import Foundation
import Decodable

struct Brand {
    let id: ObjectId
    let name: String
    let imageUrl: String
    let description: String
    var lowResImageUrl: String?
}

extension Brand {
    func appendLowResImageUrl(url: String?) -> Brand{
        return Brand(id: id, name: name, imageUrl: imageUrl, description: description, lowResImageUrl: url)
    }
}

// MARK: - Decodable, Encodable

extension Brand: Decodable {
    static func decode(json: AnyObject) throws -> Brand {
        return try Brand(
            id: json => "id",
            name: json => "name",
            imageUrl: json => "image_url",
            description: json => "description",
            lowResImageUrl: nil
        )
    }
}