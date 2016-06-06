import Foundation

class BasketManager {
    private static let fileName = "basket.json"
    
    private let storageManager: StorageManager
    
    var basket: Basket = Basket.createEmpty()
    
    var isEmpty: Bool {
        get {
            return basket.productsByBrands.count == 0
        }
    }
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func addToBasket(product: BasketProduct, brand: BasketBrand) {
        // TODO: Implement adding product to Basket
    }
    
    func removeFromBasket(product: BasketProduct) {
        // TODO: Implement removing product from basket
    }
    
    func save() throws {
        try storageManager.save(BasketManager.fileName, object: basket)
    }
    
    func load() throws -> Basket? {
        return try storageManager.load(BasketManager.fileName)
    }
    
    func isInBasket(brand: BasketBrand) -> Bool {
        return basket.productsByBrands.contains { brand.id == $0.id }
    }
    
    func isInBasket(product: BasketProduct) -> Bool {
        return basket.productsByBrands.contains { $0.products.contains(product) }
    }
    
    func isInBasket(product: ProductDetails) -> Bool {
        return basket.productsByBrands.contains { $0.products.contains { $0.id == product.id } }
    }
    
    /**
     Creates a sample basket model for testing purposes.

     - returns: Basket model with 5 products of 3 brands.
     */
    func createSampleBasket() -> Basket {
        basket = Basket(
            productsByBrands: [
                BasketBrand(
                    id: 1,
                    name: "Małgorzata Salamon",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 3,
                    products: [
                        BasketProduct(
                            id: 1,
                            name: "Sweter Serce z dekoltem na plecach",
                            imageUrl: "https://static.shwrm.net/images/w/8/w8573104cca75da_500x643.jpg",
                            size: BasketProductSize(id: 1, name: "XS"),
                            color: BasketProductColor(id: 1, name: "niebieski"),
                            basePrice: Money(amt: 400.00),
                            price: Money(amt: 299.00),
                            amount: 1
                        )
                    ]
                ),
                BasketBrand(
                    id: 1,
                    name: "RISK made in warsaw",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 3,
                    products: [
                        BasketProduct(
                            id: 1,
                            name: "Spódnica maxi The Forever Skirt",
                            imageUrl: "https://static.shwrm.net/images/g/t/gt573d85d13b9f7_500x643.jpg",
                            size: BasketProductSize(id: 0, name: "S"),
                            color: nil,
                            basePrice: Money(amt: 429.00),
                            price: nil,
                            amount: 1
                        ),
                        BasketProduct(
                            id: 1,
                            name: "Spódnica Inka white",
                            imageUrl: "https://static.shwrm.net/images/w/a/wa572b3deddf05a_500x643.jpg",
                            size: nil,
                            color: BasketProductColor(id: 1, name: "zielony"),
                            basePrice: Money(amt: 16.00),
                            price: nil,
                            amount: 1
                        )
                    ]
                ),
                BasketBrand(
                    id: 1,
                    name: "Beata Cupriak",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 7,
                    products: [
                        BasketProduct(
                            id: 1,
                            name: "Sukienka Figurynka beżowo-brązowa",
                            imageUrl: "https://static.shwrm.net/images/r/6/r6570e390c3e8cc_500x643.jpg",
                            size: BasketProductSize(id: 1, name: "36"),
                            color: BasketProductColor(id: 1, name: "brązowy"),
                            basePrice: Money(amt: 439.00),
                            price: nil,
                            amount: 1
                        ),
                        BasketProduct(
                            id: 1,
                            name: "Sukienka Crema midi z dżerseju",
                            imageUrl: "https://static.shwrm.net/images/b/o/bo570f86beaebe4_500x643.jpg",
                            size: BasketProductSize(id: 1, name: "L"),
                            color: BasketProductColor(id: 1, name: "écru"),
                            basePrice: Money(amt: 379.00),
                            price: nil,
                            amount: 1
                        )
                    ]
                ),
            ],
            discountCode: "springsale20",
            basePrice: Money(amt: 1067.00),
            price: Money(amt: 2000.00)
        )
        return basket
    }
}