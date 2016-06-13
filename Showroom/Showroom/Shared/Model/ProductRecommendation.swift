import Foundation
import Decodable

struct ProductRecommendationResult {
    let productRecommendations: [ProductRecommendation]
}

struct ProductRecommendation {
    let basePrice: Money
    let price: Money
    let itemId: String
    let category: String
    let brand: String
    let imageUrl: String
    let title: String
    let description: String?
    let available: Bool
    let url: String
}

extension ProductRecommendation {
    func toProduct() -> Product {
        return Product(
            id: Int(itemId)!,
            brand: brand,
            name: title,
            basePrice: basePrice,
            price: price,
            imageUrl: imageUrl)
    }
}

// MARK: - Decodable, Encodable

extension ProductRecommendationResult: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> ProductRecommendationResult {
        let array = json as! [AnyObject]
        return ProductRecommendationResult(productRecommendations: try array.map(ProductRecommendation.decode))
    }
    
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for productRecommendation in productRecommendations {
            encodedList.addObject(productRecommendation.encode())
        }
        return encodedList
    }
}

extension ProductRecommendation: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductRecommendation {
        return try ProductRecommendation(
            basePrice: j => "msrp",
            price: j => "price",
            itemId: j => "item",
            category: j => "category" ,
            brand: j => "brand",
            imageUrl: j => "image",
            title: j => "title",
            description: j =>? "description",
            available: j => "available",
            url: j => "link"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "msrp": basePrice.amount,
            "price": price.amount,
            "item": itemId,
            "category": category,
            "brand": brand,
            "image": imageUrl,
            "title": title,
            "available": available,
            "link": url
        ]
        if description != nil { dict.setObject(description!, forKey: "description") }
        return dict
    }
}

// MARK: - Equatable
extension ProductRecommendationResult: Equatable {}
extension ProductRecommendation: Equatable {}

func ==(lhs: ProductRecommendationResult, rhs: ProductRecommendationResult) -> Bool {
    return lhs.productRecommendations == rhs.productRecommendations
}

func ==(lhs: ProductRecommendation, rhs: ProductRecommendation) -> Bool {
    return lhs.itemId == rhs.itemId && lhs.title == rhs.title && lhs.brand == rhs.brand && lhs.description == rhs.description && lhs.url == rhs.url
}