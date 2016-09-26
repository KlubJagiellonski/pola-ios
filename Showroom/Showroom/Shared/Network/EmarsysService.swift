import Foundation
import EmarsysPredictSDK
import RxSwift

struct EmarsysService {
    let session: EMSession
    
    init(session: EMSession) {
        self.session = session
        
        session.logLevel = Constants.isDebug ? .Debug : .Warning
    }
    
    func configure(forPlatform platform: Platform) {
        session.merchantID = platform.merchantID
    }
}

extension EmarsysService {
    func contactUpdate(withUser user: User?, gender: Gender?) {
        logInfo("Contact update \(user), gender \(gender)")
        if let user = user, let gender = gender {
            let contactData = [
                "1": user.name,
                "3": user.email,
                "5": NSNumber(integer: gender.emarsysValue)
            ]
            EmarsysManager.contactUpdate(contactData, mergeID: 3)
        } else {
            EmarsysManager.contactUpdate(mergeID: nil)
        }
    }
    
    func logout() {
        logInfo("Logout")
        EmarsysManager.logout()
    }
    
    func fetchProductRecommendations() -> Observable<ProductRecommendationResult> {
        return Observable<ProductRecommendationResult>.create { observer in
            logInfo("Fetching product recommendations")
            
            let transaction = EMTransaction()
            
            let recommendationRequest = EMRecommendationRequest(logic: "HOME")
            recommendationRequest.limit = Constants.emarsysRecommendationItemsLimit
            recommendationRequest.completionHandler = { result in
                do {
                    let productRecommendations = try result.products.map { item in try ProductRecommendation.decode(item.data) }
                    let productRecommendationResult = ProductRecommendationResult(productRecommendations: productRecommendations)
                    observer.onNext(productRecommendationResult)
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            transaction.recommend(recommendationRequest)
            self.session.sendTransaction(transaction) { error in
                observer.onError(error)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
    
    func sendViewEvent(forId id: ObjectId) {
        logInfo("Sending view event \(id)")
        
        let transaction = EMTransaction()
        transaction.setView(String(id))
        session.sendTransaction(transaction) { error in
            logInfo("Could not send sendViewEvent for id \(id), error \(error)")
        }
    }
    
    func sendCartEvent(with basket: Basket) {
        logInfo("Sending cart event")
        
        let transaction = EMTransaction()
        
        var cartItems: [EMCartItem] = []
        for productsByBrand in basket.productsByBrands {
            for product in productsByBrand.products {
                cartItems.append(EMCartItem(itemID: String(product.id), price: Float(product.price.amount), quantity: Int32(product.amount)))
            }
        }
        
        transaction.setCart(cartItems)
        session.sendTransaction(transaction) { error in
            logInfo("Could not send sendCartEvent for basket \(basket), error \(error)")
        }
    }
    
    func sendSearchEvent(withQuery query: String) {
        logInfo("Sending search event \(query)")
        
        let transaction = EMTransaction()
        transaction.setSearchTerm(query)
        session.sendTransaction(transaction) { error in
            logInfo("Could not send sendSearchEvent for query \(query), error \(error)")
        }
    }
    
    func sendBrandViewEvent(withName name: String) {
        logInfo("Sending brand event \(name)")
        
        let transaction = EMTransaction()
        transaction.setKeyword(name)
        session.sendTransaction(transaction) { error in
            logInfo("Could not send sendBrandViewEvent for name \(name), error \(error)")
        }
    }
    
    func sendPurchaseEvent(withOrderId orderId: String, products: [BasketProduct]) {
        logInfo("Sending purchase event \(orderId), product \(products)")
        
        let cartItems: [EMCartItem] = products.map { product in
            return EMCartItem(itemID: String(product.id), price: Float(product.sumPrice?.amount ?? 0), quantity: Int32(product.amount))
        }
        
        let transaction = EMTransaction()
        transaction.setPurchase(orderId, ofItems: cartItems)
        session.sendTransaction(transaction) { error in
            logInfo("Could not send purchase event for orderId \(orderId), error \(error)")
        }
    }
    
    func sendCategoryEvent(withCategory category: String) {
        logInfo("Sending category event \(category)")
        
        let transaction = EMTransaction()
        transaction.setCategory(category)
        session.sendTransaction(transaction) { error in
            logInfo("Could not send category event for category \(category), error \(error)")
        }
    }
    
    func configureUser(customerId: String?, customerEmail: String?) {
        session.customerID = customerId
        session.customerEmail = customerEmail
    }
}

extension Gender {
    private var emarsysValue: Int {
        switch self {
        case .Female:
            return 2
        case .Male:
            return 1
        }
    }
}

extension Platform {
    private var merchantID: String {
        switch self {
        case .Polish:
            return Constants.emarsysMerchantId
        case .German:
            return Constants.deEmarsysMerchantId
        }
    }
}