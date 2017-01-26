import Foundation
import CocoaMarkdown
import RxSwift

final class TrendProductListModel: ProductListModel {
    private(set) var entryTrendInfo: EntryTrendInfo
    private(set) var trendInfo: TrendInfo?
    
    var attributedDescription: NSAttributedString?
    override var productDetailsFromType: ProductDetailsFromType {
        return .Trend
    }
    
    init(with apiService: ApiService, wishlistManager: WishlistManager, trendInfo: EntryTrendInfo) {
        self.entryTrendInfo = trendInfo
        super.init(with: apiService, wishlistManager: wishlistManager, link: nil, query: nil)
    }
    
    override func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [FilterId: [FilterObjectId]]?) -> Observable<ProductListResult> {
        return apiService.fetchTrend(entryTrendInfo.slug)
            .doOnNext { [weak self] result in
                guard let `self` = self, let trendInfo = result.trendInfo else { return }
                self.attributedDescription = trendInfo.description.markdownToAttributedString()
                self.trendInfo = result.trendInfo
        }
    }
    
    func update(with entryTrendInfo: EntryTrendInfo) {
        logInfo("Update with entry trend info: \(entryTrendInfo)")
        self.entryTrendInfo = entryTrendInfo
        trendInfo = nil
        attributedDescription = nil
        resetOnUpdate(withLink: nil, query: nil)
    }
}
