import Foundation
import RxSwift

class ProductPageModel {
    let api: ApiService
    
    var state: ProductPageModelState = ProductPageModelState()
    
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
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchProductDetails(id: Int) -> Observable<FetchResult<ProductDetails>> {
        return api.fetchProductDetails(withProductId: id)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] productDetails in
                self?.state.productDetails = productDetails
                self?.state.currentColor = self?.defaultColor(forProductDetails: productDetails)
                self?.state.currentSize = self?.defaultSize(forProductDetails: productDetails)
            }
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map { FetchResult.Success($0) }
            .catchError { Observable.just(FetchResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
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
    let productObservable = PublishSubject<Product?>()
    
    var product: Product? {
        didSet { productObservable.onNext(product) }
    }
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
}