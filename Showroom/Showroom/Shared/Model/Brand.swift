import Foundation

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