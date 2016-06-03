import Foundation

struct ProductSize: CustomStringConvertible {
    let id: ObjectId
    let size: String
    let isAvailable: Bool
    
    var description: String { return size }
}