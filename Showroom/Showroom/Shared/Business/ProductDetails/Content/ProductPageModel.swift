import Foundation
import RxSwift

class ProductPageModel {
    let api: ApiService
    let storageManager: StorageManager
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
            return (product.name + " " + product.name, NSURL(string: baseUrl + String(product.id))!)
            
        } else if let productDetails = state.productDetails {
            return (productDetails.brand.name + " " + productDetails.name, NSURL(string: baseUrl + String(productDetails.id))!)
            
        } else {
            return nil
        }
    }
    
    init(api: ApiService, storageManager: StorageManager, productId: ObjectId, product: Product? = nil) {
        self.api = api
        self.storageManager = storageManager
        self.productId = productId
        cacheId = Constants.Cache.productDetails + String(productId)
        state = ProductPageModelState(product: product)
    }
    
    func fetchProductDetails() -> Observable<FetchCacheResult<ProductDetails>> {
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
            .merge().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                self?.state.productDetails = result.result()
                guard let productDetails = result.result() else { return }
                self?.state.currentSize = self?.defaultSize(forProductDetails: productDetails)
                self?.state.currentColor = self?.defaultColor(forProductDetails: productDetails)
            }
    }
    
    func changeSelectedSize(forSizeId sizeId: ObjectId) {
        guard let productDetails = state.productDetails else { return }
        state.currentSize = productDetails.sizes.find { $0.id == sizeId }
        self.updateBuyButtonState()
    }
    
    func changeSelectedColor(forColorId colorId: ObjectId) {
        guard let productDetails = state.productDetails else { return }
        state.currentColor = productDetails.colors.find { $0.id == colorId }!
        guard let selectedSize = state.currentSize else { return }
        let sizeExistForColor = selectedSize.colors.contains { $0 == state.currentColor?.id }
        if !sizeExistForColor {
            state.currentSize = nil
            self.updateBuyButtonState()
        }
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
        state.buyButtonEnabled = state.currentColor != nil && state.currentSize != nil
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