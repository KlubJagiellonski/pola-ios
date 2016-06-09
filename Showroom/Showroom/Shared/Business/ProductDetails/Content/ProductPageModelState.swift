import Foundation
import RxSwift

class ProductPageModelState {
    let currentSizeObservable = PublishSubject<ProductDetailsSize?>()
    let currentColorObservable = PublishSubject<ProductDetailsColor?>()
    
    var product: Product?
    var productDetails: ProductDetails?
    var currentSize: ProductDetailsSize? {
        didSet {
            currentSizeObservable.onNext(currentSize)
        }
    }
    var currentColor: ProductDetailsColor? {
        didSet {
            currentColorObservable.onNext(currentColor)
        }
    }
    
    init() { }
    
    init(product: Product) {
        self.product = product
    }
    
    init(productDetails: ProductDetails, currentColor: ProductDetailsColor, currentSize: ProductDetailsSize? = nil) {
        self.productDetails = productDetails
        self.currentSize = currentSize
        self.currentColor = currentColor
    }
}