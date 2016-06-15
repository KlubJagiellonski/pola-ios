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
    
    var productsCount: Int {
        var count = 0
        for brand in productsByBrands {
            count += brand.products.count
        }
        return count
    }
    
    static func createEmpty() -> Basket {
        return Basket(productsByBrands: [], discountCode: nil, basePrice: Money(), price: nil)
    }
    
    mutating func remove(product: BasketProduct) {
        guard let brandIndex = productsByBrands.indexOf({ $0.products.contains(product) }) else {
            return
        }
        productsByBrands[brandIndex].remove(product)
        if productsByBrands[brandIndex].products.count == 0 {
            productsByBrands.removeAtIndex(brandIndex)
        }
    }
    
    mutating func add(product: BasketProduct, of brand: BasketBrand) {
        if let brandIndex = productsByBrands.indexOf(brand) {
            productsByBrands[brandIndex].add(product)
        } else {
            var newBrand = brand
            newBrand.removeAllProducts()
            newBrand.add(product)
            productsByBrands.append(newBrand)
        }
    }
    
    mutating func update(product: BasketProduct) {
        guard let brandIndex = productsByBrands.indexOf({ $0.products.contains(product) }) else {
            return
        }
        productsByBrands[brandIndex].update(product)
    }
}

struct BasketBrand: Equatable {
    let id: Int
    let name: String
    let shippingPrice: Money
    let waitTime: Int
    var products: [BasketProduct] = []
    
    init(id: Int, name: String, shippingPrice: Money, waitTime: Int, products: [BasketProduct]) {
        self.id = id
        self.name = name
        self.shippingPrice = shippingPrice
        self.waitTime = waitTime
        self.products = products
    }
    
    init(id: Int, name: String, waitTime: Int) {
        self.id = id
        self.name = name
        self.shippingPrice = Money()
        self.waitTime = waitTime
    }
    
    init(from product: ProductDetails) {
        self.id = product.brand.id
        self.name = product.brand.name
        self.shippingPrice = Money()
        self.waitTime = product.waitTime
    }
    
    mutating func remove(product: BasketProduct) {
        guard let productIndex = products.indexOf(product) else {
            return
        }
        products.removeAtIndex(productIndex)
    }
    
    mutating func add(product: BasketProduct) {
        if let productIndex = products.indexOf(product) {
            products[productIndex].amount += 1
        } else {
            products.append(product)
        }
    }
    
    mutating func update(product: BasketProduct) {
        guard let productIndex = products.indexOf(product) else {
            return
        }
        products[productIndex] = product
    }
    
    mutating func removeAllProducts() {
        products.removeAll()
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
    var amount: Int = 1
    
    init (id: Int, name: String, imageUrl: String?, size: BasketProductSize?, color: BasketProductColor?, basePrice: Money, price: Money?, amount: Int) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.size = size
        self.color = color
        self.basePrice = basePrice
        self.price = price
        self.amount = amount
    }
    
    init (id: Int, name: String, imageUrl: String?, size: BasketProductSize?, color: BasketProductColor?, basePrice: Money, price: Money?) {
        self.init(id: id, name: name, imageUrl: imageUrl, size: size, color: color, basePrice: basePrice, price: price, amount: 1)
    }
}

struct BasketProductColor: Equatable {
    let id: Int
    let name: String
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    init(from color: ProductDetailsColor) {
        self.id = color.id
        self.name = color.name
    }
}

struct BasketProductSize: Equatable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from size: ProductDetailsSize) {
        self.id = size.id
        self.name = size.name
    }
}

// MARK: - Operators handling
func == (lhs: BasketBrand, rhs: BasketBrand) -> Bool {
    return lhs.id == rhs.id
}

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
            products: productsArray.map(BasketProduct.decode))
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