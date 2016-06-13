import Foundation

class BasketModel {
    private let apiService: ApiService
    private let basketManager: BasketManager
    
    var basket: Basket {
        return basketManager.basket
    }
    
    var isEmpty: Bool {
        return basket.isEmpty
    }
    
    init(apiService: ApiService, basketManager: BasketManager) {
        self.apiService = apiService
        self.basketManager = basketManager
    }
    
    func load() throws {
        try basketManager.load()
    }
    
    func saveCurrentBasket() throws {
        try basketManager.save()
    }
    
    func removeFromBasket(product: BasketProduct) {
        basketManager.basket.removeProduct(product)
    }
    
    func createSampleBasket() {
        basketManager.createSampleBasket()
    }
}
