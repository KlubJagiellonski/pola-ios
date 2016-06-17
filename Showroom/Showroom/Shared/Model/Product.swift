import Foundation
import Decodable

typealias MeasurementName = String
typealias FabricPercent = Int
typealias TimeInDays = Int

struct Product {
    let id: ObjectId
    let brand: String
    let name: String
    let basePrice: Money
    let price: Money
    let imageUrl: String
    let lowResImageUrl: String?
}

struct ProductDetails {
    let id: ObjectId
    let brand: ProductDetailsBrand
    let name: String
    let basePrice: Money
    let price: Money
    let images: [ProductDetailsImage]
    let colors: [ProductDetailsColor]
    let sizes: [ProductDetailsSize]
    let fabrics: [ProductDetailsFabric]
    let waitTime: TimeInDays
    let description: [String]
    let emarsysCategory: String
    let freeDelivery: Bool
}

struct ProductDetailsBrand {
    let id: ObjectId
    let name: String
}

struct ProductDetailsImage {
    let url: String
    let color: ObjectId?
}

enum ProductDetailsColorType: String {
    case RGB = "RGB"
    case Image = "Image"
}

struct ProductDetailsColor {
    let id: ObjectId
    let name: String
    let type: ProductDetailsColorType
    let value: String
    let sizes: [ObjectId]
}

struct ProductDetailsSize {
    let id: ObjectId
    let name: String
    let colors: [ObjectId]
    let measurements: [MeasurementName: String]
}

struct ProductDetailsFabric {
    let name: String
    let percentage: Int
}

// MARK: - Decodable, Encodable

extension ProductDetails: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetails {
        return try ProductDetails(
            id: j => "id",
            brand: j => "store",
            name: j => "name",
            basePrice: j => "msrp",
            price: j => "price",
            images: j => "images" => "available",
            colors: j => "colors",
            sizes: j => "sizes",
            fabrics: j => "fabrics",
            waitTime: j => "wait_time",
            description: j => "description",
            emarsysCategory: j => "emarsys_category",
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
            "images": ["available": images.map { $0.encode() } as NSArray] as NSDictionary,
            "colors": colors.map { $0.encode() } as NSArray,
            "sizes": sizes.map { $0.encode() } as NSArray,
            "fabrics": fabrics.map { $0.encode() } as NSArray,
            "wait_time": waitTime,
            "description": description as NSArray,
            "emarsys_category": emarsysCategory,
            "free_delivery": freeDelivery
        ]
        return dict
    }
}

extension ProductDetailsBrand: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetailsBrand {
        return try ProductDetailsBrand(
            id: j => "id",
            name: j => "name"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name
        ]
        return dict
    }
}

extension ProductDetailsImage: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetailsImage {
        return try ProductDetailsImage(
            url: j => "url",
            color: j =>? "color"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "url": url
        ]
        if color != nil { dict.setObject(color!, forKey: "color") }
        return dict
    }
}

extension ProductDetailsColor: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetailsColor {
        return try ProductDetailsColor(
            id: j => "id",
            name: j => "name",
            type: j => "type",
            value: j => "value",
            sizes: j => "sizes"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name,
            "type": type.rawValue,
            "value": value,
            "sizes": sizes as NSArray
        ]
        return dict
    }
}

extension ProductDetailsColorType: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsColorType {
        return ProductDetailsColorType(rawValue: j as! String)!
    }
}

extension ProductDetailsSize: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetailsSize {
        return try ProductDetailsSize(
            id: j => "id",
            name: j => "name",
            colors: j => "colors",
            measurements: j => "measurements"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name,
            "colors": colors as NSArray,
            "measurements": measurements as NSDictionary
        ]
        return dict
    }
}

extension ProductDetailsFabric: Decodable, Encodable {
    static func decode(j: AnyObject) throws -> ProductDetailsFabric {
        return try ProductDetailsFabric(
            name: j => "name",
            percentage: j => "percentage"
        )
    }
    
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "name": name,
            "percentage": percentage
        ]
        return dict
    }
}

// MARK: - Equatable

extension ProductDetails: Equatable {}
extension ProductDetailsBrand: Equatable {}
extension ProductDetailsImage: Equatable {}
extension ProductDetailsColor: Equatable {}
extension ProductDetailsColorType: Equatable {}
extension ProductDetailsSize: Equatable {}
extension ProductDetailsFabric: Equatable {}

func ==(lhs: ProductDetails, rhs: ProductDetails) -> Bool {
    return lhs.id == rhs.id && lhs.brand == rhs.brand && lhs.name == rhs.name && lhs.basePrice == rhs.basePrice && lhs.price == rhs.price && lhs.images == rhs.images && lhs.colors == rhs.colors && lhs.sizes == rhs.sizes && lhs.fabrics == rhs.fabrics && lhs.waitTime == rhs.waitTime && lhs.description == rhs.description && lhs.freeDelivery == rhs.freeDelivery
}

func ==(lhs: ProductDetailsBrand, rhs: ProductDetailsBrand) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}

func ==(lhs: ProductDetailsImage, rhs: ProductDetailsImage) -> Bool {
    return lhs.color == rhs.color && lhs.url == rhs.url
}

func ==(lhs: ProductDetailsColor, rhs: ProductDetailsColor) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.sizes == rhs.sizes && lhs.type == rhs.type && lhs.value == rhs.value
}

func ==(lhs: ProductDetailsSize, rhs: ProductDetailsSize) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.colors == rhs.colors && lhs.measurements == rhs.measurements
}

func ==(lhs: ProductDetailsFabric, rhs: ProductDetailsFabric) -> Bool {
    return lhs.name == rhs.name && lhs.percentage == rhs.percentage
}