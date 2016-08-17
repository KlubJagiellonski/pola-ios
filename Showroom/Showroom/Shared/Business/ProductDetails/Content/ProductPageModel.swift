import Foundation
import RxSwift

class ProductPageModel {
    typealias IsOnWishlist = Bool
    
    let api: ApiService
    let basketManager: BasketManager
    let storageManager: StorageManager
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
        let baseUrl = "https://www.showroom.pl/p/"
        
        if let product = state.product {
            return (product.brand + " " + product.name, NSURL(string: baseUrl + String(product.id))!)
            
        } else if let productDetails = state.productDetails {
            return (productDetails.brand.name + " " + productDetails.name, NSURL(string: baseUrl + String(productDetails.id))!)
            
        } else {
            return nil
        }
    }
    
    var isSizeSet: Bool { return state.currentSize != nil }
    
    var isOnWishlist: IsOnWishlist {
        return wishlistManager.containsProduct(withId: productId)
    }
    
    init(api: ApiService, basketManager: BasketManager, storageManager: StorageManager, wishlistManager: WishlistManager, productId: ObjectId, product: Product? = nil) {
        self.api = api
        self.storageManager = storageManager
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
        
        let diskCache: Observable<ProductDetails> = Observable.retrieveFromCache(cacheId, storageManager: storageManager)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = api.fetchProductDetails(withProductId: productId)
            .saveToCache(cacheId, storageManager: storageManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .concat().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                guard let productDetails = result.result() else { return }
                
                logInfo("Fetchend product details")
                
                self?.state.productDetails = result.result()
                self?.updateBuyButtonState()
                self?.state.currentSize = self?.defaultSize(forProductDetails: productDetails)
                self?.state.currentColor = self?.defaultColor(forProductDetails: productDetails)
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
    
    private func updateBuyButtonState() {
        state.buyButtonEnabled = state.productDetails != nil
    }
}

class ProductPageModelState {
    let currentSizeObservable = PublishSubject<ProductDetailsSize?>()
    let currentColorObservable = PublishSubject<ProductDetailsColor?>()
    let buyButtonObservable = PublishSubject<Bool>()
    let productDetailsObservable = PublishSubject<ProductDetails?>()
    
    var product: Product?
    var productDetails: ProductDetails? {
        didSet { productDetailsObservable.onNext(productDetails) }
    }
    var currentSize: ProductDetailsSize? {
        didSet { currentSizeObservable.onNext(currentSize) }
    }
    var currentColor: ProductDetailsColor? {
        didSet { currentColorObservable.onNext(currentColor) }
    }
    var buyButtonEnabled: Bool = false {
        didSet { buyButtonObservable.onNext(buyButtonEnabled) }
    }

    init(product: Product?) {
        self.product = product
    }
}