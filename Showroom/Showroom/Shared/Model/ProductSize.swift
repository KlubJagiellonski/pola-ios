import Foundation

struct ProductSize: CustomStringConvertible {
    let id: ObjectId
    let size: String
    let isAvailable: Bool
    
    var description: String { return size }
    
    init(productDetailsSize: ProductDetailsSize, isAvailable: Bool) {
        self.id = productDetailsSize.id
        self.size = productDetailsSize.name
        self.isAvailable = isAvailable
    }
    
    init(id: ObjectId, size: String, isAvailable: Bool) {
        self.id = id
        self.size = size
        self.isAvailable = isAvailable
    }
}