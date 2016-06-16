import Foundation
import RxSwift

class BasketManager {
    private static let fileName = "basket.json"
    
    private let apiService: ApiService
    private let storageManager: StorageManager
    let basketObservable = PublishSubject<Basket>()
    
    private(set) var currentBasket: Basket = Basket.createEmpty() {
        didSet {
            basketObservable.onNext(currentBasket)
        }
    }
    
    init(apiService: ApiService, storageManager: StorageManager) {
        self.apiService = apiService
        self.storageManager = storageManager
    }
    
    func verify(basket: Basket) -> Basket {
        // TODO: Make API request
        return basket
    }
    
    func addToBasket(product: BasketProduct, of brand: BasketBrand) {
        currentBasket.add(product, of: brand)
        currentBasket = verify(currentBasket)
    }
    
    func removeFromBasket(product: BasketProduct) {
        currentBasket.remove(product)
        currentBasket = verify(currentBasket)
    }
    
    func updateInBasket(product: BasketProduct) {
        if (product.amount == 0) {
            currentBasket.remove(product)
        } else {
            currentBasket.update(product)
        }
        currentBasket = verify(currentBasket)
    }
    
    func save() throws {
        try storageManager.save(BasketManager.fileName, object: currentBasket)
    }
    
    func load() throws -> Basket? {
        return try storageManager.load(BasketManager.fileName)
    }
    
    func isInBasket(brand: BasketBrand) -> Bool {
        return currentBasket.productsByBrands.contains { brand.id == $0.id }
    }
    
    func isInBasket(product: BasketProduct) -> Bool {
        return currentBasket.productsByBrands.contains { $0.products.contains({ $0.isEqualInBasket(to: product) }) }
    }
    
    func isInBasket(product: ProductDetails) -> Bool {
        return currentBasket.productsByBrands.contains { $0.products.contains { $0.id == product.id } }
    }
    
    /**
     Creates a sample basket model for testing purposes.

     - returns: Basket model with 5 products of 3 brands.
     */
    func createSampleBasket() -> Basket {
        currentBasket = Basket(
            productsByBrands: [
                BasketBrand(
                    id: 1,
                    name: "Małgorzata Salamon",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 3,
                    products: [
                        BasketProduct(
                            id: 11,
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
                    id: 2,
                    name: "RISK made in warsaw",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 3,
                    products: [
                        BasketProduct(
                            id: 12,
                            name: "Spódnica maxi The Forever Skirt",
                            imageUrl: "https://static.shwrm.net/images/g/t/gt573d85d13b9f7_500x643.jpg",
                            size: BasketProductSize(id: 0, name: "S"),
                            color: BasketProductColor(id: 12, name: "biały"),
                            basePrice: Money(amt: 429.00),
                            price: nil,
                            amount: 1
                        ),
                        BasketProduct(
                            id: 13,
                            name: "Spódnica Inka white",
                            imageUrl: "https://static.shwrm.net/images/w/a/wa572b3deddf05a_500x643.jpg",
                            size: BasketProductSize(id: 0, name: "S"),
                            color: BasketProductColor(id: 1, name: "zielony"),
                            basePrice: Money(amt: 16.00),
                            price: nil,
                            amount: 1
                        )
                    ]
                ),
                BasketBrand(
                    id: 3,
                    name: "Beata Cupriak",
                    shippingPrice: Money(amt: 10.0),
                    waitTime: 7,
                    products: [
                        BasketProduct(
                            id: 14,
                            name: "Sukienka Figurynka beżowo-brązowa",
                            imageUrl: "https://static.shwrm.net/images/r/6/r6570e390c3e8cc_500x643.jpg",
                            size: BasketProductSize(id: 1, name: "36"),
                            color: BasketProductColor(id: 1, name: "brązowy"),
                            basePrice: Money(amt: 439.00),
                            price: nil,
                            amount: 1
                        ),
                        BasketProduct(
                            id: 15,
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
        return currentBasket
    }
}