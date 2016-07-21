import Foundation
import RxSwift

final class WishlistManager {
    private let storageManager: StorageManager
    private let disposeBag = DisposeBag()
    
    let state: WishlistState
    
    init(with storageManager: StorageManager) {
        self.storageManager = storageManager
        
        state = WishlistState()
        state.wishlist = createSampleData()
    }
    
    func synchronize() {
        state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
        
        // TODO: Make API request
        
        state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: true)
    }
    
    func addToWishlist(product: ListProduct) {
        if state.wishlist.contains ({ $0.id == product.id }) {
            return
        }
        state.wishlist.append(product)
        synchronize()
    }
    
    func removeFromWishlist(product: ListProduct) {
        state.wishlist.remove { $0.id == product.id }
    }
    
    func createWishlistProductsContext(initialIndex: Int, onChangedForIndex: Int -> ()) -> ProductDetailsContext? {
        if state.wishlist[safe: initialIndex] == nil {
            return nil
        }
        
        let onRetrieveProductInfo: Int -> ProductInfo = { index in
            let product = self.state.wishlist[index]
            let lowResImageUrl = NSURL.createImageUrl(product.imageUrl, width: WishlistCell.photoSize.width, height: WishlistCell.photoSize.height)
            return ProductInfo.Object(product.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
        }
        
        return OnePageProductDetailsContext(productsCount: state.wishlist.count, initialProductIndex: initialIndex, onChanged: onChangedForIndex, onRetrieveProductInfo: onRetrieveProductInfo)
    }
    
    func createSampleData() -> [ListProduct] {
        return [
            ListProduct(id: 56425,
                brand: ProductBrand(id: 0, name: "Baltica"),
                name: "Bluza Oversize",
                basePrice: Money(amt: 219.0),
                price: Money(amt: 219.0),
                imageUrl: "https://static.shwrm.net/images/j/1/j157874aacc5b88_500x643.jpg?1468484268",
                freeDelivery: true,
                premium: false,
                new: true),
            ListProduct(id: 71626,
                brand: ProductBrand(id: 1, name: "PASO a PASO"),
                name: "Sandałki Silvia silver",
                basePrice: Money(amt: 310.0),
                price: Money(amt: 248.0),
                imageUrl: "https://static.shwrm.net/images/o/q/oq578a03f18b0e4_500x643.jpg?1468662769",
                freeDelivery: true,
                premium: true,
                new: true),
            ListProduct(id: 61505,
                brand: ProductBrand(id: 2, name: "Beata Cupriak"),
                name: "Sukienka Figurynka granatowo-koralowa",
                basePrice: Money(amt: 439.0),
                price: Money(amt: 319.0),
                imageUrl: "https://static.shwrm.net/images/m/8/m8570e37d31ea10_500x643.jpg?1460549587",
                freeDelivery: true,
                premium: false,
                new: false)
        ]
    }
}

struct WishlistSynchronizationState {
    let synchronizing: Bool
    let synchronized: Bool
}

final class WishlistState {
    let wishlistObservable = PublishSubject<[ListProduct]>()
    let synchronizationStateObservable = PublishSubject<WishlistSynchronizationState>()
    
    var wishlist: [ListProduct] = [] {
        didSet { wishlistObservable.onNext(wishlist) }
    }
    
    var synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false) {
        didSet { synchronizationStateObservable.onNext(synchronizationState) }
    }
}