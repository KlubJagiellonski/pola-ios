import Foundation
import RxSwift

final class ProductPageModel {
    typealias IsOnWishlist = Bool
    
    let api: ApiService
    let basketManager: BasketManager
    private let storage: KeyValueStorage
    let wishlistManager: WishlistManager
    let productId: Int
    let cacheId: String
    
    var state: ProductPageModelState
    
    var pickerSizes: [ProductSize]? {
        guard let productDetails = state.productDetails else { return nil }
        guard let currentColor = state.currentColor else { return nil }
        return productDetails.sizes.map { size in
            let isAvailable = !size.colors.filter { currentColor.id == $0 }.isEmpty
            return ProductSize(productDetailsSize: size, isAvailable: isAvailable)
        }
    }
    
    var pickerColors: [ProductColor]? {
        guard let productDetails = state.productDetails else { return nil }
        return productDetails.colors.map { color in ProductColor(productDetailsColor: color, isAvailable: true) }
    }
    
    var productSharingInfo: (desc: String, url: NSURL)? {
        if let productDetails = state.productDetails, let url = NSURL(string: productDetails.link) {
            return (productDetails.brand.name + " " + productDetails.name, url)
        } else {
            return nil
        }
    }
    
    var isSizeSet: Bool { return state.currentSize != nil }
    
    var isOnWishlist: IsOnWishlist {
        return wishlistManager.containsProduct(withId: productId)
    }
    
    init(api: ApiService, basketManager: BasketManager, storage: KeyValueStorage, wishlistManager: WishlistManager, productId: ObjectId, product: Product? = nil) {
        self.api = api
        self.storage = storage
        self.basketManager = basketManager
        self.wishlistManager = wishlistManager
        self.productId = productId
        cacheId = Constants.Cache.productDetails + String(productId)
        state = ProductPageModelState(product: product)
    }
    
    func fetchProductDetails() -> Observable<FetchCacheResult<ProductDetails>> {
        logInfo("Fetching product details")
        
        let existingResult = state.productDetails
        let memoryCache: Observable<ProductDetails> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<ProductDetails> = Observable.load(forKey: cacheId, storage: storage, type: .Cache)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0, .Cache) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = api.fetchProductDetails(withProductId: productId)
            .save(forKey: cacheId, storage: storage, type: .Cache)
            .map { FetchCacheResult.Success($0, .Network) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .concat().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                guard let productDetails = result.result() else { return }
                
                logInfo("Fetchend product details")
                
                self?.state.productDetails = result.result()
                
                if productDetails.available {
                    self?.state.currentSize = self?.defaultSize(forProductDetails: productDetails)
                    self?.state.currentColor = self?.defaultColor(forProductDetails: productDetails)
                } else {
                    self?.state.currentSize = nil
                    self?.state.currentColor = nil
                }
        }
    }
    
    func changeSelectedSize(forSizeId sizeId: ObjectId) {
        logInfo("Changing selected size with id \(sizeId)")
        guard let productDetails = state.productDetails else {
            logError("Cannot change size, not product details")
            return
        }
        state.currentSize = productDetails.sizes.find { $0.id == sizeId }
    }
    
    func changeSelectedColor(forColorId colorId: ObjectId) {
        logInfo("Changing selected color with id \(colorId)")
        guard let productDetails = state.productDetails else {
            logError("Cannot change color, not product details")
            return
        }
        state.currentColor = productDetails.colors.find { $0.id == colorId }
        guard let selectedSize = state.currentSize else {
            return
        }
        let sizeExistForColor = selectedSize.colors.contains { $0 == state.currentColor?.id }
        if !sizeExistForColor {
            logInfo("Size does not exist for color, unseting")
            state.currentSize = nil
        }
    }
    
    func addToBasket() {
        guard let product = state.productDetails else {
            fatalError("Could not init BasketProduct because product details are not initialized.")
        }
        guard let size = state.currentSize else {
            fatalError("Could not init BasketProduct because size is not specified.")
        }
        guard let color = state.currentColor else {
            fatalError("Could not init BasketProduct because color is not specified.")
        }
        
        var imageUrl: String!
        if let image = product.images.find({ $0.color == color.id }) {
            imageUrl = image.url
        } else {
            imageUrl = product.images.first?.url
        }
        
        let basketProduct = BasketProduct(
            id: product.id,
            name: product.name,
            imageUrl: imageUrl,
            size: BasketProductSize(from: size),
            color: BasketProductColor(from: color),
            basePrice: product.basePrice,
            price: product.price)
        let brand = BasketBrand(from: product)
        basketManager.addToBasket(basketProduct, of: brand)
    }
    
    /// Adds or removes the product from the Wishlist depending on the current state.
    func switchOnWishlist() -> IsOnWishlist {
        if (wishlistManager.containsProduct(withId: productId)) {
            wishlistManager.removeFromWishlistProduct(withId: productId)
            // Product has been removed from the Wishlist
            return false
        }
        
        guard let product = state.productDetails else {
            return false
        }
        guard let wishlistProduct = WishlistProduct(productDetails: product) else {
            return false
        }
        
        wishlistManager.addToWishlist(wishlistProduct)
        
        // Product has been added to the Wishlist
        return true
    }
    
    private func defaultSize(forProductDetails productDetails: ProductDetails) -> ProductDetailsSize? {
        guard let color = defaultColor(forProductDetails: productDetails) else { return nil }
        guard let sizeId = color.sizes.first else { return nil }
        return productDetails.sizes.find { $0.id == sizeId }
    }
    
    private func defaultColor(forProductDetails productDetails: ProductDetails) -> ProductDetailsColor? {
        return productDetails.colors.first
    }
}

class ProductPageModelState {
    let currentSizeObservable = PublishSubject<ProductDetailsSize?>()
    let currentColorObservable = PublishSubject<ProductDetailsColor?>()
    let productDetailsObservable = PublishSubject<ProductDetails?>()
    
    var product: Product?
    var productDetails: ProductDetails? {
        didSet {
            if let productDetails = productDetails {
                let urls = productDetails.videos.map { NSURL(string: $0.url)! }
                videoCacheHelper = VideoCacheHelper(urls: urls)
            } else {
                videoCacheHelper = nil
            }
            productDetailsObservable.onNext(productDetails)
        }
    }
    var currentSize: ProductDetailsSize? {
        didSet { currentSizeObservable.onNext(currentSize) }
    }
    var currentColor: ProductDetailsColor? {
        didSet { currentColorObservable.onNext(currentColor) }
    }
    var videoCacheHelper: VideoCacheHelper?

    init(product: Product?) {
        self.product = product
    }
}
