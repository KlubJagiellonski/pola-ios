import Foundation
import CocoaMarkdown
import RxSwift

final class BrandProductListModel: ProductListModel {
    private(set) var productBrand: EntryProductBrand
    var brand: BrandDetails?
    
    override var productDetailsFromType: ProductDetailsFromType {
        return .Brand
    }
    
    var attributedDescription: NSAttributedString?
    
    init(with apiService: ApiService, wishlistManager: WishlistManager, productBrand: EntryProductBrand) {
        self.productBrand = productBrand
        super.init(with: apiService, wishlistManager: wishlistManager, link: productBrand.link, query: nil)
    }

    override func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [FilterId: [FilterObjectId]]?) -> Observable<ProductListResult> {
        let request = ProductRequest(paginationInfo: paginationInfo, link: link, filter: filters, search: nil)
        return apiService.fetchBrand(forBrandId: productBrand.id, request: request)
            .doOnNext { [weak self] result in
                guard let `self` = self, let brand = result.brand else { return }
                self.attributedDescription = brand.description.markdownToAttributedString()
                self.brand = brand
                logAnalyticsEvent(AnalyticsEventId.ListBrand(brand.name))
        }
    }
    
    func update(with productBrand: EntryProductBrand) {
        logInfo("Update with product brand: \(productBrand)")
        self.productBrand = productBrand
        self.brand = nil
        self.attributedDescription = nil
        resetOnUpdate(withLink: productBrand.link, query: nil)
    }
}
