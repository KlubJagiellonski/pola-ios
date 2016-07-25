import Foundation
import RxSwift

final class WishlistManager {
    private let storageManager: StorageManager
    private let disposeBag = DisposeBag()
    private var contextWishlist: [ListProduct] = []
    
    let state: WishlistState
    
    init(with storageManager: StorageManager) {
        self.storageManager = storageManager
        
        state = WishlistState()
    }
    
    func synchronize() {
        state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
        
        // TODO: Make API request
        
        state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: true)
    }
    
    func containsProduct(withId id: Int) -> Bool {
        return state.wishlist.contains ({ $0.id == id })
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
    
    func removeFromWishlistProduct(withId id: Int) {
        state.wishlist.remove { $0.id == id }
    }
    
    func createWishlistProductsContext(initialIndex: Int, onChangedForIndex: Int -> ()) -> ProductDetailsContext? {
        if state.wishlist[safe: initialIndex] == nil {
            return nil
        }
        
        contextWishlist = state.wishlist
        
        let onRetrieveProductInfo: Int -> ProductInfo = { index in
            let product = self.contextWishlist[index]
            let lowResImageUrl = NSURL.createImageUrl(product.imageUrl, width: WishlistCell.photoSize.width, height: WishlistCell.photoSize.height)
            return ProductInfo.Object(product.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
        }
        
        return OnePageProductDetailsContext(productsCount: state.wishlist.count, initialProductIndex: initialIndex, onChanged: onChangedForIndex, onRetrieveProductInfo: onRetrieveProductInfo)
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