import Foundation

class BasketModel {
    private let apiService: ApiService
    private let basketManager: BasketManager
    
    var basket: Basket {
        get {
            return basketManager.basket
        }
    }
    
    var isEmpty: Bool {
        get {
            return basketManager.isEmpty
        }
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
    
    func createSampleBasket() {
        basketManager.createSampleBasket()
    }
}
