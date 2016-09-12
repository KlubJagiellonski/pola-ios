import UIKit

struct ProductColor: CustomStringConvertible {
    let id: ObjectId
    let name: String
    let color: ColorRepresentation
    let isAvailable: Bool
    
    var description: String { return name }
    
    init(productDetailsColor detailsColor: ProductDetailsColor, isAvailable: Bool) {
        self.id = detailsColor.id
        self.name = detailsColor.name
        switch detailsColor.type {
        case .RGB:
            self.color = .Color(UIColor(hex: detailsColor.value)!)
        case .Image:
            self.color = .ImageUrl(detailsColor.value)
        }
        self.isAvailable = isAvailable
    }
    
    init(id: ObjectId, name: String, color: ColorRepresentation, isAvailable: Bool) {
        self.id = id
        self.name = name
        self.color = color
        self.isAvailable = isAvailable
    }
}

typealias Url = String

enum ColorRepresentation {
    case None
    case Color(UIColor)
    case ImageUrl(Url)
}
