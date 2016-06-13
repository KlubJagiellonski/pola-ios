import Foundation
import RxSwift

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
    var productInfosObservable: Observable<[ProductInfo]> { get }
    var productInfos: [ProductInfo] { get }
    var initialProductIndex: Int { get }
    
    func productDetailsDidMoveToProduct(atIndex index: Int)
}

class OnePageProductDetailsContext: ProductDetailsContext {
    let productInfos: [ProductInfo]
    let productInfosObservable: Observable<[ProductInfo]> = PublishSubject.empty()
    let initialProductIndex: Int
    let onChanged: Int -> Void
    
    init(productInfos: [ProductInfo], initialProductIndex: Int, onChanged: Int -> Void) {
        self.productInfos = productInfos
        self.initialProductIndex = initialProductIndex
        self.onChanged = onChanged
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {
        onChanged(index)
    }
}

class OneProductDetailsContext: ProductDetailsContext {
    let productInfos: [ProductInfo]
    let productInfosObservable: Observable<[ProductInfo]> = PublishSubject.empty()
    let initialProductIndex: Int
    
    init(productInfo: ProductInfo) {
        self.productInfos = [productInfo]
        self.initialProductIndex = 0
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {}
}