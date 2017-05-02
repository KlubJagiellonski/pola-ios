import Foundation
import RxSwift

typealias ProductsCount = Int

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

enum ProductDetailsFromType: String {
    case Category = "category"
    case Trend = "trend"
    case Brand = "designer"
    case Wishlist = "wishlist"
    case Basket = "basket"
    case HomeContentPromo = "home_content_promo"
    case HomeRecommendation = "home_recommendation"
    case DeepLink = "deeplink"
    case Video = "video"
}

protocol ProductDetailsContext: class {
    var productsCountObservable: Observable<ProductsCount> { get }
    var productsCount: Int { get }
    var initialProductIndex: Int { get }
    var fromType: ProductDetailsFromType { get }
    var link: NSURL? { get }
    
    func productInfo(forIndex index: Int) -> ProductInfo
    func productDetailsDidMoveToProduct(atIndex index: Int)
}

class MultiPageProductDetailsContext: ProductDetailsContext {
    let productsCountObservable: Observable<ProductsCount> = PublishSubject()
    var productsCount: Int {
        didSet {
            let newProductsSubject = productsCountObservable as! PublishSubject
            newProductsSubject.onNext(productsCount)
        }
    }
    let initialProductIndex: Int
    let onChanged: Int -> ()
    let onRetrieveProductInfo: Int -> ProductInfo
    let fromType: ProductDetailsFromType
    let link: NSURL? = nil
    
    init(productsCount: Int, initialProductIndex: Int, fromType: ProductDetailsFromType, onChanged: Int -> (), onRetrieveProductInfo: Int -> ProductInfo) {
        self.productsCount = productsCount
        self.initialProductIndex = initialProductIndex
        self.onChanged = onChanged
        self.onRetrieveProductInfo = onRetrieveProductInfo
        self.fromType = fromType
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {
        onChanged(index)
    }
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return onRetrieveProductInfo(index)
    }
}

class OnePageProductDetailsContext: ProductDetailsContext {
    let productsCountObservable: Observable<ProductsCount> = PublishSubject.empty()
    let productsCount: Int
    let initialProductIndex: Int
    let onChanged: Int -> Void
    let onRetrieveProductInfo: Int -> ProductInfo
    let fromType: ProductDetailsFromType
    let link: NSURL? = nil
    
    init(productsCount: Int, initialProductIndex: Int, fromType: ProductDetailsFromType, onChanged: Int -> (), onRetrieveProductInfo: Int -> ProductInfo) {
        self.productsCount = productsCount
        self.initialProductIndex = initialProductIndex
        self.onChanged = onChanged
        self.onRetrieveProductInfo = onRetrieveProductInfo
        self.fromType = fromType
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
    let productsCountObservable: Observable<ProductsCount> = PublishSubject.empty()
    let initialProductIndex = 0
    let productInfo: ProductInfo
    let fromType: ProductDetailsFromType
    let link: NSURL?
    
    init(productInfo: ProductInfo, fromType: ProductDetailsFromType, link: NSURL?) {
        self.productInfo = productInfo
        self.fromType = fromType
        self.link = link
    }
    
    func productDetailsDidMoveToProduct(atIndex index: Int) {}
    
    func productInfo(forIndex index: Int) -> ProductInfo {
        return productInfo
    }
}
