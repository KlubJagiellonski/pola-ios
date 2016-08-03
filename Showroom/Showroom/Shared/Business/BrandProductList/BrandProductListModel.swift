import Foundation
import CocoaMarkdown
import RxSwift

final class BrandProductListModel: ProductListModel {
    private let emarsysService: EmarsysService
    private(set) var productBrand: EntryProductBrand
    var brand: Brand?
    
    override var productDetailsFromType: ProductDetailsFromType {
        return .Brand
    }
    
    var attributedDescription: NSAttributedString?
    
    init(with apiService: ApiService, wishlistManager: WishlistManager, emarsysService: EmarsysService, productBrand: EntryProductBrand) {
        self.productBrand = productBrand
        self.emarsysService = emarsysService
        super.init(with: apiService, wishlistManager: wishlistManager, link: productBrand.link)
    }

    override func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [FilterId: [FilterObjectId]]?) -> Observable<ProductListResult> {
        let request = ProductRequest(paginationInfo: paginationInfo, link: link, filter: filters)
        return apiService.fetchBrand(forBrandId: productBrand.id, request: request)
            .doOnNext { [weak self] result in
                guard let `self` = self, let brand = result.brand else { return }
                self.attributedDescription = brand.description.markdownToAttributedString()
                self.brand = brand
                self.emarsysService.sendBrandViewEvent(withName: brand.name)
        }
    }
    
    func update(with productBrand: EntryProductBrand) {
        self.productBrand = productBrand
        self.brand = nil
        self.attributedDescription = nil
    }
}