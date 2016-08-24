import Foundation
import RxSwift
import UIKit

class ProductListModel {
    let apiService: ApiService
    let emarsysService: EmarsysService
    private let wishlistManager: WishlistManager
    private var page = 1
    private(set) var products: [ListProduct] = []
    private(set) var link: String?
    private(set) var query: String?
    private(set) var totalProductsAmount = 0
    private var filters: [Filter]?
    private var entryFilters: [Filter]?
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
    var userSeenWishlistInAppOnboarding: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userSeenWishlistInAppOnboarding") }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userSeenWishlistInAppOnboarding") }
    }
    
    init(with apiService: ApiService, emarsysService: EmarsysService, wishlistManager: WishlistManager, link: String?, query: String?) {
        self.apiService = apiService
        self.emarsysService = emarsysService
        self.wishlistManager = wishlistManager
        self.link = link
        self.query = query
    }
    
    func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [FilterId: [FilterObjectId]]?) -> Observable<ProductListResult> {
        let request = ProductRequest(paginationInfo: paginationInfo, link: link, filter: filters, search: query == nil ? nil : SearchInfo(query: query!))
        return apiService.fetchProducts(with: request)
    }
    
    final func fetchFirstPage() -> Observable<ProductListResult> {
        page = 1
        products = []
        let paginationInfo = PaginationInfo(page: page, pageSize: defaultPageSize)
        return createObservable(with: paginationInfo, forFilters: createRequestFilters(filters))
            .doOnNext { [weak self](result: ProductListResult) in
                guard let `self` = self else { return }
                self.link = nil
                self.filters = result.filters
                if self.entryFilters == nil {
                    self.entryFilters = self.filters
                }
                self.products.appendContentsOf(result.products)
                self.totalProductsAmount = result.totalResults
                if let emarsysCategory = result.emarsysCategory {
                    self.emarsysService.sendCategoryEvent(withCategory: emarsysCategory)
                }
        }
            .observeOn(MainScheduler.instance)
    }
    
    final func fetchNextProductPage() -> Observable<ProductListResult> {
        let paginationInfo = PaginationInfo(page: page + 1, pageSize: defaultPageSize)
        return createObservable(with: paginationInfo, forFilters: createRequestFilters(filters))
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
    
    final func createProductDetailsContext(withProductIndex index: Int, withImageWidth imageWidth: Int) -> ProductDetailsContext {
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
        wishlistManager.addToWishlist(WishlistProduct(listProduct: products[index]))
    }
    
    final func createFilterContext() -> ProductFilterContext? {
        guard filters != nil && entryFilters != nil else { return nil }
        
        let fetchObservable = {
            [unowned self] (filters: [Filter]) -> Observable<ProductListResult> in
            let paginationInfo = PaginationInfo(page: 1, pageSize: self.defaultPageSize)
            return self.createObservable(with: paginationInfo, forFilters: self.createRequestFilters(filters))
        }
        
        return ProductFilterContext(entryFilters: entryFilters!, filters: filters!, totalProductsAmount: totalProductsAmount, fetchObservable: fetchObservable)
    }
    
    final func didChangeFilter(withResult productListResult: ProductListResult) {
        page = 1
        link = nil
        filters = productListResult.filters
        products = productListResult.products
        totalProductsAmount = productListResult.totalResults
        if let emarsysCategory = productListResult.emarsysCategory {
            self.emarsysService.sendCategoryEvent(withCategory: emarsysCategory)
        }
    }

    final func resetOnUpdate(withLink link: String?, query: String?) {
        self.link = link
        self.query = query
        self.entryFilters = nil
        self.filters = nil
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