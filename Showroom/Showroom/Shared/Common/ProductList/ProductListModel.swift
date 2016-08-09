import Foundation
import RxSwift
import UIKit

class ProductListModel {
    let apiService: ApiService
    private let wishlistManager: WishlistManager
    private var page = 1
    private(set) var products: [ListProduct] = []
    private(set) var link: String?
    private var filters: [Filter]?
    var currentPageIndex: Int {
        return page - 1
    }
    let productIndexObservable: Observable<Int?> = PublishSubject()
    private(set) var productIndex: Int?
    weak var currentProductDetailsContext: MultiPageProductDetailsContext?
    var isBigScreen = false
    private var defaultPageSize: Int {
        return isBigScreen ? Constants.productListPageSizeForLargeScreen : Constants.productListPageSize
    }
    var productDetailsFromType: ProductDetailsFromType {
        return .Category
    }
    
    init(with apiService: ApiService, wishlistManager: WishlistManager, link: String?) {
        self.apiService = apiService
        self.wishlistManager = wishlistManager
        self.link = link
    }
    
    func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [Filter]?) -> Observable<ProductListResult> {
        let request = ProductRequest(paginationInfo: paginationInfo, link: link, filter: createRequestFilters(filters))
        return apiService.fetchProducts(with: request)
    }
    
    final func fetchFirstPage() -> Observable<ProductListResult> {
        page = 1
        products = []
        let paginationInfo = PaginationInfo(page: page, pageSize: defaultPageSize)
        return createObservable(with: paginationInfo, forFilters: filters)
            .doOnNext { [weak self](result: ProductListResult) in
                self?.link = nil
                self?.filters = result.filters
                self?.products.appendContentsOf(result.products)
        }
            .observeOn(MainScheduler.instance)
    }
    
    final func fetchNextProductPage() -> Observable<ProductListResult> {
        let paginationInfo = PaginationInfo(page: page + 1, pageSize: defaultPageSize)
        return createObservable(with: paginationInfo, forFilters: filters)
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
        
        let productDetailsContext = MultiPageProductDetailsContext(productsCount: products.count, initialProductIndex: index, fromType: productDetailsFromType, onChanged: onChanged, onRetrieveProductInfo: onRetrieveProductInfo)
        currentProductDetailsContext = productDetailsContext
        return productDetailsContext
    }
    
    final func addToWishlist(productAtIndex index: Int) {
        wishlistManager.addToWishlist(products[index])
    }
    
    final func createFilterContext() -> ProductFilterContext? {
        guard filters != nil else { return nil }
        
        let fetchObservable = {
            [unowned self] (filters: [Filter]) -> Observable<ProductListResult> in
            let paginationInfo = PaginationInfo(page: 1, pageSize: self.defaultPageSize)
            return self.createObservable(with: paginationInfo, forFilters: filters)
        }
        
        return ProductFilterContext(filters: filters!, fetchObservable: fetchObservable)
    }
    
    final func didChangeFilter(withResult productListResult: ProductListResult) {
        page = 1
        link = nil
        filters = productListResult.filters
        products = productListResult.products
    }
    
    private func updateProductIndexWithNotyfingObserver(with index: Int?) {
        self.productIndex = index
        let productIndexSubject = productIndexObservable as! PublishSubject
        productIndexSubject.onNext(productIndex)
    }
    
    private func createRequestFilters(filters: [Filter]?) -> [FilterId: [FilterObjectId]]? {
        guard filters != nil else { return nil }
        var requestFilters: [FilterId: [FilterObjectId]] = [:]
        for filter in filters! {
            if !filter.data.isEmpty {
                requestFilters[filter.id] = filter.data
            }
        }
        return requestFilters
    }
}