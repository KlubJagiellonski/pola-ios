import Foundation
import Decodable

struct ProductRecommendationResult {
    let productRecommendations: [ProductRecommendation]
}

struct ProductRecommendation {
    let msrp: Double
    let itemId: String
    let category: String
    let brand: String
    let imageUrl: String
    let title: String
    let description: String?
    let price: Money
    let available: Bool
    let url: String
}

// MARK: - Decodable
extension ProductRecommendationResult: Decodable {
    static func decode(json: AnyObject) throws -> ProductRecommendationResult {
        let array = json as! [AnyObject]
        return ProductRecommendationResult(productRecommendations: try array.map(ProductRecommendation.decode))
    }
}

extension ProductRecommendation: Decodable {
    static func decode(j: AnyObject) throws -> ProductRecommendation {
        return try ProductRecommendation(
            msrp: j => "msrp",
            itemId: j => "item",
            category: j => "category" ,
            brand: j => "brand",
            imageUrl: j => "image",
            title: j => "title",
            description: j =>? "description",
            price: j => "price",
            available: j => "available",
            url: j => "link"
        )
    }
}

// MARK: - Encodable
extension ProductRecommendationResult: Encodable {
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for productRecommendation in productRecommendations {
            encodedList.addObject(productRecommendation.encode())
        }
        return encodedList
    }
}

extension ProductRecommendation: Encodable {
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "msrp": msrp,
            "item": itemId,
            "category": category,
            "brand": brand,
            "image": imageUrl,
            "title": title,
            "price": price.amount,
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