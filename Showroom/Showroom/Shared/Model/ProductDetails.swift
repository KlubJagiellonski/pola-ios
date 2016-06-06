import Foundation
import Decodable

typealias ObjectId = Int
typealias MeasurementName = String
typealias FabricPercent = Int
typealias TimeInDays = Int

struct ProductDetails {
    let id: ObjectId
    let brand: ProductDetailsBrand
    let name: String
    let basePrice: Money
    let price: Money
    let images: [ProductDetailsImage]
    let colors: [ProductDetailsColor]
    let sizes: [ProductDetailsSize]
    let fabrics: [String: FabricPercent]
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
    let measurements: [MeasurementName: Int]
}

// MARK: - Decodable

extension ProductDetails: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetails {
        return try ProductDetails(
            id: j => "id",
            brand: j => "store",
            name: j => "name",
            basePrice: j => "msrp",
            price: j => "price",
            images: j => "images",
            colors: j => "colors",
            sizes: j => "sizes",
            fabrics: j => "fabrics",
            waitTime: j => "wait_time",
            description: j => "description",
            emarsysCategory: j => "emarsys_category",
            freeDelivery: j => "free_delivery"
        )
    }
}

extension ProductDetailsBrand: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsBrand {
        return try ProductDetailsBrand(
            id: j => "id",
            name: j => "name"
        )
    }
}

extension ProductDetailsImage: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsImage {
        return try ProductDetailsImage(
            url: j => "url",
            color: j =>? "color"
        )
    }
}

extension ProductDetailsColor: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsColor {
        return try ProductDetailsColor(
            id: j => "id",
            name: j => "name",
            type: j => "type",
            value: j => "value",
            sizes: j => "sizes"
        )
    }
}

extension ProductDetailsColorType: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsColorType {
        return ProductDetailsColorType(rawValue: j as! String)!
    }
}

extension ProductDetailsSize: Decodable {
    static func decode(j: AnyObject) throws -> ProductDetailsSize {
        return try ProductDetailsSize(
            id: j => "id",
            name: j => "name",
            colors: j => "colors",
            measurements: j => "measurements"
        )
    }
}