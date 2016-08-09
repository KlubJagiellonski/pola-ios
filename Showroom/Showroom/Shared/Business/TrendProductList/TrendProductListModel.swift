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
        super.init(with: apiService, wishlistManager: wishlistManager, link: nil)
    }
    
    override func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [Filter]?) -> Observable<ProductListResult> {
        return apiService.fetchTrend(entryTrendInfo.slug)
            .doOnNext { [weak self] result in
                self?.attributedDescription = result.trendInfo!.description.markdownToAttributedString()
                self?.trendInfo = result.trendInfo
        }
    }
    
    func update(with entryTrendInfo: EntryTrendInfo) {
        self.entryTrendInfo = entryTrendInfo
        trendInfo = nil
        attributedDescription = nil
    }
}