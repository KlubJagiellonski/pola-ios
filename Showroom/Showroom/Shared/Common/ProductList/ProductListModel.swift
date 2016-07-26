import Foundation
import RxSwift
import UIKit

class ProductListModel {
    let apiService: ApiService
    private let wishlistManager: WishlistManager
    private var page = 1
    private var products: [ListProduct] = []
    var currentPageIndex: Int {
        return page - 1
    }
    let productIndexObservable: Observable<Int?> = PublishSubject()
    private(set) var productIndex: Int?
    weak var currentProductDetailsContext: MultiPageProductDetailsContext?
    var isBigScreen = false
    
    init(with apiService: ApiService, wishlistManager: WishlistManager) {
        self.apiService = apiService
        self.wishlistManager = wishlistManager
    }
    
    func createObservable(page: Int) -> Observable<ProductListResult> {
        return apiService.fetchProducts(page, pageSize: isBigScreen ? Constants.productListPageSizeForLargeScreen : Constants.productListPageSize)
    }
    
    final func fetchFirstPage() -> Observable<ProductListResult> {
        page = 1
        products = []
        return createObservable(page)
            .doOnNext { [weak self](result: ProductListResult) in
                self?.products.appendContentsOf(result.products)
        }
            .observeOn(MainScheduler.instance)
    }
    
    final func fetchNextProductPage() -> Observable<ProductListResult> {
        return createObservable(page + 1)
            .doOnNext { [weak self](result: ProductListResult) in
                self?.products.appendContentsOf(result.products)
        }
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self](result: ProductListResult) in
                self?.currentProductDetailsContext?.productsCount += result.products.count
        }
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .doOnNext { [weak self] _ in self?.page += 1 }
            .observeOn(MainScheduler.instance)
    }
    
    final func createProductDetailsContext(withProductIndex index: Int, withImageWidth imageWidth: CGFloat) -> ProductDetailsContext {
        productIndex = index
        let onChanged = { [unowned self](index: Int) -> () in
            self.updateProductIndexWithNotyfingObserver(with: index)
        }
        
        let onRetrieveProductInfo = { [unowned self](index: Int) -> ProductInfo in
            let product = self.products[index]
            let lowResImageUrl = NSURL.createImageUrl(product.imageUrl, width: imageWidth, height: nil)
            return ProductInfo.Object(product.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
        }
        
        let productDetailsContext = MultiPageProductDetailsContext(productsCount: products.count, initialProductIndex: index, onChanged: onChanged, onRetrieveProductInfo: onRetrieveProductInfo)
        currentProductDetailsContext = productDetailsContext
        return productDetailsContext
    }
    
    final func addToWishlist(productAtIndex index: Int) {
        wishlistManager.addToWishlist(products[index])
    }
    
    private func updateProductIndexWithNotyfingObserver(with index: Int?) {
        self.productIndex = index
        let productIndexSubject = productIndexObservable as! PublishSubject
        productIndexSubject.onNext(productIndex)
    }
}