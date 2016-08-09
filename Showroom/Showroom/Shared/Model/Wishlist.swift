import Foundation
import Decodable

struct WishlistResult {
    let id: ObjectId
    let ownerId: ObjectId
    let name: String
    let products: [ListProduct]
}

struct SingleWishlistRequest {
    let productId: ObjectId
}

struct MultipleWishlistRequest {
    let productIds: [ObjectId]
}

// MARK: - Decodable, Encodable

extension WishlistResult: Encodable, Decodable {
    static func decode(json: AnyObject) throws -> WishlistResult {
        return try WishlistResult(
            id: json => "id",
            ownerId: json => "ownerId",
            name: json => "name",
            products: json =>? "products" ?? []
        )
    }
    
    func encode() -> AnyObject {
        return [
            "id": id,
            "ownerId": ownerId,
            "name": name,
            "products": products.map { $0.encode() } as NSArray
        ] as NSDictionary
    }
}

extension SingleWishlistRequest: Encodable {
    func encode() -> AnyObject {
        return [
            "productId": productId
        ] as NSDictionary
    }
}

extension MultipleWishlistRequest: Encodable {
    func encode() -> AnyObject {
        return [
            "productsIds": productIds as NSArray
        ] as NSDictionary
    }
}