import Foundation
import Decodable

struct WishlistProduct {
    let id: ObjectId
    let brand: Brand
    let name: String
    let basePrice: Money
    let price: Money
    let imageUrl: String
    let freeDelivery: Bool
}

struct WishlistResult {
    let id: ObjectId
    let ownerId: ObjectId
    let name: String
    let products: [WishlistProduct]
}

struct SingleWishlistRequest {
    let productId: ObjectId
}

struct MultipleWishlistRequest {
    let productIds: [ObjectId]
}

// MARK:- Utilities

extension WishlistProduct {
    init(listProduct: ListProduct) {
        self.id = listProduct.id
        self.brand = listProduct.brand
        self.name = listProduct.name
        self.basePrice = listProduct.basePrice
        self.price = listProduct.price
        self.imageUrl = listProduct.imageUrl
        self.freeDelivery = listProduct.freeDelivery
    }
    
    init?(productDetails: ProductDetails) {
        guard let imageUrl = productDetails.images.first?.url else {
            logError("Could not init WishlistProduct beacuse there are no images available.")
            return nil
        }
        
        self.id = productDetails.id
        self.brand = productDetails.brand
        self.name = productDetails.name
        self.basePrice = productDetails.basePrice
        self.price = productDetails.price
        self.imageUrl = imageUrl
        self.freeDelivery = productDetails.freeDelivery
    }
    
    func toProduct(withLowResImageUrl lowResImageUrl: String?) -> Product {
        return Product(
            id: id,
            brand: brand.name,
            name: name,
            basePrice: basePrice,
            price: price,
            imageUrl: imageUrl,
            lowResImageUrl: lowResImageUrl)
    }
}

// MARK:- Decodable, Encodable

extension WishlistProduct: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> WishlistProduct {
        return try WishlistProduct(
            id: j => "id",
            brand: j => "store",
            name: j => "name",
            basePrice: j => "msrp",
            price: j => "price",
            imageUrl: j => "images" => "default" => "url",
            freeDelivery: j => "free_delivery"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "id": id,
            "store": brand.encode(),
            "name": name,
            "msrp": basePrice.amount,
            "price": price.amount,
            "images": ["default": ["url": imageUrl]],
            "free_delivery": freeDelivery
        ]
        return dict
    }
}

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

//MARK:- Equatable

extension WishlistProduct: Equatable {}

func ==(lhs: WishlistProduct, rhs: WishlistProduct) -> Bool {
    return lhs.id == rhs.id && lhs.brand == rhs.brand && lhs.basePrice == rhs.basePrice && lhs.price == rhs.price && lhs.imageUrl == rhs.imageUrl && lhs.freeDelivery == rhs.freeDelivery
}