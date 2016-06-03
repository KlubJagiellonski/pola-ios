import UIKit

struct ProductColor: CustomStringConvertible {
    let id: ObjectId
    let name: String
    let color: ColorRepresentation
    let isAvailable: Bool
    
    var description: String { return name }
}

typealias Url = String

enum ColorRepresentation {
    case Color(UIColor)
    case ImageUrl(Url)
}
