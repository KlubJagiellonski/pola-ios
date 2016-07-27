import Foundation
import RxSwift
import Decodable

final class WishlistManager {
    private let storageManager: StorageManager
    private let disposeBag = DisposeBag()
    private var contextWishlist: [ListProduct] = []
    
    let state: WishlistState
    
    init(with storageManager: StorageManager) {
        self.storageManager = storageManager
        
        var wishlistState: WishlistState? = nil
        do {
            wishlistState = try storageManager.load(Constants.Persistent.wishlistState)
        } catch {
            logError("Error while loading wishlist state from persistent storage: \(error)")
        }
        self.state = wishlistState ?? WishlistState()
    }
    
    func synchronize() {
        state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
        
        // TODO: Make API request
        do {
            try storageManager.save(Constants.Persistent.wishlistState, object: state)
        } catch {
            logError("Error while saving wihslist state to persistent storage: \(error)")
        }
        
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
        synchronize()
    }
    
    func removeFromWishlistProduct(withId id: Int) {
        state.wishlist.remove { $0.id == id }
        synchronize()
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

// MARK:- Encodable, Decodable

extension WishlistState: Encodable, Decodable {
    static func decode(json: AnyObject) throws -> WishlistState {
        let state = WishlistState()
        state.wishlist = try json => "wishlist"
        return state
    }
    
    func encode() -> AnyObject {
        let wishlistArray: NSMutableArray = []
        for product in wishlist {
            wishlistArray.addObject(product.encode())
        }
        return ["wishlist": wishlistArray]
    }
}