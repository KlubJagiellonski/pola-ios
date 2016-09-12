import Foundation
import RxSwift
import Decodable
import RxCocoa

/*
 * How it works?
 * - on every app foreground entry, changing tab to wishlist or login/register it is checking if wishlist is synchronized. If YES then it should do `GET wishlist`. If NOT then it should do `POST wishlist`
 * - before on every wishlist add/remove it is checking if wishlist is validated. If NOT it should do `POST wishlist`. If YES it should do `PUT wishlist` / `DELETE wishlist`. If on of request will fail then wishlist is marked as not synchronized.
 * - it should mark as not synchronized when user log out
 */

final class WishlistManager {
    private let storageManager: StorageManager
    private let userManager: UserManager
    private let api: ApiService
    private let disposeBag = DisposeBag()
    private var contextWishlist: [WishlistProduct] = []
    private var synchronizationDisposable: Disposable?
    
    let state: WishlistState
    
    init(with storageManager: StorageManager, and userManager: UserManager, and api: ApiService) {
        self.storageManager = storageManager
        self.userManager = userManager
        self.api = api
        
        var wishlistState: WishlistState? = nil
        do {
            wishlistState = try storageManager.load(Constants.Persistent.wishlistState)
        } catch {
            logError("Error while loading wishlist state from persistent storage: \(error)")
        }
        self.state = wishlistState ?? WishlistState()
        
        userManager.sessionObservable.subscribeNext { [weak self] session in
            guard let `self` = self else { return }
            logInfo("Session changed \(session)")
            if session == nil {
                self.synchronizationDisposable?.dispose()
                self.state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false)
            } else {
                self.synchronize()
            }
        }.addDisposableTo(disposeBag)
    }
    
    func synchronize() {
        guard !state.synchronizationState.synchronizing else {
            logInfo("Synchronization is already in a way.")
            return
        }
        
        if state.synchronizationState.synchronized {
            logInfo("Not need to synchronize, just fetching wishlist")
            state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
            synchronizationDisposable = handleObservable(api.fetchWishlist(), alwaysMarkAsSynchronized: true)
        } else if userManager.session != nil {
            logInfo("User logged, need to synchronize")
            state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
            let productsIds = state.wishlist.reverse().map { $0.id }
            synchronizationDisposable = handleObservable(api.sendWishlist(with: MultipleWishlistRequest(productIds: productsIds)), alwaysMarkAsSynchronized: false)
        } else {
            logInfo("User not logged, need to synchronize")
            state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false)
        }
    }
    
    func containsProduct(withId id: Int) -> Bool {
        return state.wishlist.contains ({ $0.id == id })
    }
    
    func addToWishlist(product: WishlistProduct) {
        if state.wishlist.contains ({ $0.id == product.id }) {
            logInfo("Cannot add product to wishlist. It already exist \(product)")
            return
        }
        
        logInfo("Adding to wishlist product with id \(product.id)")
        
        state.wishlist.append(product)
        saveStateToStorage()
        
        if let synchronizationDisposable = synchronizationDisposable {
            synchronizationDisposable.dispose()
        }
        guard userManager.session != nil else {
            state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false)
            return
        }
        state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
        synchronizationDisposable = handleObservable(api.addToWishlist(with: SingleWishlistRequest(productId: product.id)), alwaysMarkAsSynchronized: false)
    }
    
    func removeFromWishlist(product: WishlistProduct) {
        removeFromWishlistProduct(withId: product.id)
    }
    
    func removeFromWishlistProduct(withId id: Int) {
        logInfo("Removing from wishlist product with id \(id)")
        
        state.wishlist.remove { $0.id == id }
        saveStateToStorage()
        
        if let synchronizationDisposable = synchronizationDisposable {
            synchronizationDisposable.dispose()
        }
        guard userManager.session != nil else {
            state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false)
            return
        }
        state.synchronizationState = WishlistSynchronizationState(synchronizing: true, synchronized: state.synchronizationState.synchronized)
        synchronizationDisposable = handleObservable(api.deleteFromWishlist(with: SingleWishlistRequest(productId: id)), alwaysMarkAsSynchronized: false)
    }
    
    func createWishlistProductsContext(initialIndex: Int, onChangedForIndex: Int -> ()) -> ProductDetailsContext? {
        if state.wishlist[safe: initialIndex] == nil {
            logError("Cannot create wishlist products context. Index does not exist \(initialIndex), wishlist \(state.wishlist)")
            return nil
        }
        
        contextWishlist = state.wishlist
        
        let onRetrieveProductInfo: Int -> ProductInfo = { index in
            logInfo("Retrieving product info for index \(index)")
            let product = self.contextWishlist[index]
            let imageWidth = UIImageView.scaledImageSize(WishlistCell.photoSize.width)
            let lowResImageUrl = NSURL.createImageUrl(product.imageUrl, width: imageWidth, height: nil)
            return ProductInfo.Object(product.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
        }
        
        return OnePageProductDetailsContext(productsCount: state.wishlist.count, initialProductIndex: initialIndex, fromType: .Wishlist, onChanged: onChangedForIndex, onRetrieveProductInfo: onRetrieveProductInfo)
    }
    
    private func handleObservable(observable: Observable<WishlistResult>, alwaysMarkAsSynchronized: Bool) -> Disposable{
        return observable
            .map { result in
                return WishlistResult(id: result.id, ownerId: result.ownerId, name: result.name, products: Array(result.products.reverse()))
            }
            .doOnNext { [weak self] result in
                guard let `self` = self else { return }
                
                let state = WishlistState(wishlist: result.products, wishlistResult: result, synchronizationState: WishlistSynchronizationState(synchronizing: false, synchronized: true))
                try self.storageManager.save(Constants.Persistent.wishlistState, object: state)
        }
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                switch event {
                case .Next(let result):
                    logInfo("Succedded to fetch wishlist \(result)")
                    self.state.wishlistResult = result
                    self.state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: true)
                case .Error(let error):
                    logInfo("Did not succedded to fetch wishlist \(error)")
                    self.state.synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: alwaysMarkAsSynchronized ? true : false)
                default: break
                }
        }
    }
    
    private func saveStateToStorage() {
        logInfo("Saving state to storage")
        do {
            try self.storageManager.save(Constants.Persistent.wishlistState, object: state)
        } catch {
            logError("Cannot save wishlist to storage \(error)")
        }
    }
}

struct WishlistSynchronizationState {
    let synchronizing: Bool
    let synchronized: Bool
}

final class WishlistState {
    let wishlistObservable = PublishSubject<[WishlistProduct]>()
    let synchronizationStateObservable = PublishSubject<WishlistSynchronizationState>()
    
    var wishlist: [WishlistProduct] = [] {
        didSet {
            guard oldValue != wishlist else { return }
            wishlistObservable.onNext(wishlist)
        }
    }
    private(set) var wishlistResult: WishlistResult? {
        didSet {
            wishlist = wishlistResult?.products ?? []
        }
    }
    
    private(set) var synchronizationState = WishlistSynchronizationState(synchronizing: false, synchronized: false) {
        didSet { synchronizationStateObservable.onNext(synchronizationState) }
    }
    
    init () { }
    
    init(wishlist: [WishlistProduct], wishlistResult: WishlistResult?, synchronizationState: WishlistSynchronizationState) {
        self.wishlist = wishlist
        self.wishlistResult = wishlistResult
        self.synchronizationState = synchronizationState
    }
}

// MARK:- Encodable, Decodable

extension WishlistState: Encodable, Decodable {
    static func decode(json: AnyObject) throws -> WishlistState {
        return try WishlistState(
            wishlist: json => "wishlist",
            wishlistResult: try json =>? "wishlistResult",
            synchronizationState: try json => "synchronizationState"
        )
    }
    
    func encode() -> AnyObject {
        let dict = [
            "synchronizationState": synchronizationState.encode(),
            "wishlist": wishlist.map { $0.encode() } as NSArray
        ] as NSMutableDictionary
        if wishlistResult != nil { dict.setObject(wishlistResult!.encode(), forKey: "wishlistResult") }
        return dict
    }
}

extension WishlistSynchronizationState: Encodable, Decodable {
    static func decode(json: AnyObject) throws -> WishlistSynchronizationState {
        return try WishlistSynchronizationState(
            synchronizing: json => "synchronizing",
            synchronized: json => "synchronized"
        )
    }
    
    func encode() -> AnyObject {
        return [
            "synchronizing": synchronizing,
            "synchronized": synchronized
        ] as NSDictionary
    }
}
