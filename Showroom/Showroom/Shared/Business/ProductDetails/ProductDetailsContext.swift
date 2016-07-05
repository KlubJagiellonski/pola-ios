import Foundation
import RxSwift

typealias NewProductsAmount = Int

enum ProductInfo {
    case Object(Product)
    case Id(ObjectId)
    
    func toTuple() -> (ObjectId, Product?) {
        switch self {
        case .Object(let product):
            return (product.id, product)
        case .Id(let productId):
            return (productId, nil)
        }
    }
}

protocol ProductDetailsContext: class {
    var newProductsObservable: Observable<NewProductsAmount> { get }
    var productsCount: Int { get }
    var initialProductIndex: Int { get }
    
    func productInfo(forIndex index: Int) -> ProductInfo
    func productDetailsDidMoveToProduct(atIndex index: Int)
}

class MultiPageProductDetailsContext: ProductDetailsContext {
    let newProductsObservable: Observable<NewProductsAmount> = PublishSubject()
    var productsCount: Int {
        didSet {
            let newProductsSubject = newProductsObservable as! PublishSubject
            newProductsSubject.onNext(productsCount - oldValue)
        }
    }
    let initialProductIndex: Int
    let onChanged: Int -> ()
    let onRetrieveProductInfo: Int -> ProductInfo
    
    init(productsCount: Int, initialProductIndex: Int, onChanged: Int -> (), onRetrieveProductInfo: Int -> ProductInfo) {
        self.productsCount = productsCount
        self.initialProductIndex = initialProductIndex
        self.onChanged = onChanged
        self.onRetrieveProductInfo = onRetrieveProductInfo
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {
        onChanged(index)
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return onRetrieveProductInfo(index)
    }
}

class OnePageProductDetailsContext: ProductDetailsContext {
    let newProductsObservable: Observable<NewProductsAmount> = PublishSubject.empty()
    let productsCount: Int
    let initialProductIndex: Int
    let onChanged: Int -> Void
    let onRetrieveProductInfo: Int -> ProductInfo
    
    init(productsCount: Int, initialProductIndex: Int, onChanged: Int -> (), onRetrieveProductInfo: Int -> ProductInfo) {
        self.productsCount = productsCount
        self.initialProductIndex = initialProductIndex
        self.onChanged = onChanged
        self.onRetrieveProductInfo = onRetrieveProductInfo
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {
        onChanged(index)
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return onRetrieveProductInfo(index)
    }
}

class OneProductDetailsContext: ProductDetailsContext {
    let productsCount = 1
    let newProductsObservable: Observable<NewProductsAmount> = PublishSubject.empty()
    let initialProductIndex = 0
    let productInfo: ProductInfo
    
    init(productInfo: ProductInfo) {
        self.productInfo = productInfo
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {}
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return productInfo
    }
}