import Foundation
import Decodable

struct Basket {
    var productsByBrands: [BasketBrand]
    let discountCode: String?
    let basePrice: Money
    let price: Money?
    
    var isEmpty: Bool {
        return productsByBrands.count == 0
    }
    
    static func createEmpty() -> Basket {
        return Basket(productsByBrands: [], discountCode: nil, basePrice: Money(), price: nil)
    }
    
    mutating func removeProduct(product: BasketProduct) {
        guard let brandIndex = productsByBrands.indexOf({ $0.products.contains(product) }) else {
            return
        }
        productsByBrands[brandIndex].removeProduct(product)
        if productsByBrands[brandIndex].products.count == 0 {
            productsByBrands.removeAtIndex(brandIndex)
        }
    }
}

struct BasketBrand {
    let id: Int
    let name: String
    let shippingPrice: Money
    let waitTime: Int
    var products: [BasketProduct]
    
    mutating func removeProduct(product: BasketProduct) {
        guard let productIndex = products.indexOf(product) else {
            return
        }
        products.removeAtIndex(productIndex)
    }
}

struct BasketProduct: Equatable {
    let id: Int
    let name: String
    let imageUrl: String?
    let size: BasketProductSize?
    let color: BasketProductColor?
    let basePrice: Money
    let price: Money?
    let amount: Int
}

struct BasketProductColor: Equatable {
    let id: Int
    let name: String
}

struct BasketProductSize: Equatable {
    let id: Int
    let name: String
}

// MARK: - Operators handling
func == (lhs: BasketProduct, rhs: BasketProduct) -> Bool {
    return lhs.id == rhs.id && lhs.color == rhs.color && lhs.size == rhs.size
}

func == (lhs: BasketProductColor, rhs: BasketProductColor) -> Bool {
    return lhs.id == rhs.id
}

func == (lhs: BasketProductSize, rhs: BasketProductSize) -> Bool {
    return lhs.id == rhs.id
}

// MARK: - Decodable
extension Basket: Decodable {
    static func decode(j: AnyObject) throws -> Basket {
        let brandsArray: [AnyObject] = try j => "brands" as! [AnyObject]
        
        return try Basket(
            productsByBrands: brandsArray.map(BasketBrand.decode),
            discountCode: j =>? "discount_code",
            basePrice: j => "msrp",
            price: j =>? "price"
        )
    }
}

extension BasketBrand: Decodable {
    static func decode(j: AnyObject) throws -> BasketBrand {
        let productsArray: [AnyObject] = try j => "products" as! [AnyObject]
        return try BasketBrand(
            id: j => "id",
            name: j => "name",
            shippingPrice: j => "shipping_price",
            waitTime: j => "wait_time",
            products:productsArray.map(BasketProduct.decode))
    }
}

extension BasketProduct: Decodable {
    static func decode(j: AnyObject) throws -> BasketProduct {
        return try BasketProduct(
            id: j => "id",
            name: j => "name",
            imageUrl: j =>? "image_url",
            size: j =>? "size",
            color: j =>? "color",
            basePrice: j => "msrp",
            price: j =>? "price",
            amount: j => "amount"
        )
    }
}

extension BasketProductSize: Decodable {
    static func decode(j: AnyObject) throws -> BasketProductSize {
        return try BasketProductSize(
            id: j => "id",
            name: j => "name"
        )
    }
}

extension BasketProductColor: Decodable {
    static func decode(j: AnyObject) throws -> BasketProductColor {
        return try BasketProductColor(
            id: j => "id",
            name: j => "name"
        )
    }
}

// MARK: - Encodable
extension Basket: Encodable {
    func encode() -> AnyObject {
        let brandsArray: NSMutableArray = []
        for brand in productsByBrands {
            brandsArray.addObject(brand.encode())
        }
        let dict: NSMutableDictionary = [
            "brands": brandsArray,
            "msrp": basePrice.amount
        ]
        if discountCode != nil {
            dict.setObject(discountCode!, forKey: "discount_code")
        }
        if price != nil {
            dict.setObject(price!.amount, forKey: "price")
        }
        return dict
    }
}

extension BasketBrand: Encodable {
    func encode() -> AnyObject {
        let productsArray: NSMutableArray = []
        for product in products {
            productsArray.addObject(product.encode())
        }
        let dict: NSDictionary = [
            "id": id,
            "name": name,
            "shipping_price": shippingPrice.amount,
            "wait_time": waitTime,
            "products": productsArray
        ]
        return dict
    }
}

extension BasketProduct: Encodable {
    func encode() -> AnyObject {
        let dict: NSMutableDictionary = [
            "id": id,
            "name": name,
            "msrp": basePrice.amount,
            "amount": amount
        ]
        if imageUrl != nil {
            dict.setObject(imageUrl!, forKey: "image_url")
        }
        if size != nil {
            dict.setObject(size!.encode(), forKey: "size")
        }
        if color != nil {
            dict.setObject(color!.encode(), forKey: "color")
        }
        return dict
    }
}

extension BasketProductSize: Encodable {
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name
        ]
        return dict
    }
}

extension BasketProductColor: Encodable {
    func encode() -> AnyObject {
        let dict: NSDictionary = [
            "id": id,
            "name": name
        ]
        return dict
    }
}