import Foundation
import CocoaMarkdown
import RxSwift

final class TrendProductListModel: ProductListModel {
    private(set) var entryTrendInfo: EntryTrendInfo
    private(set) var trendInfo: TrendInfo?
    
    var attributedDescription: NSAttributedString?
    
    init(with apiService: ApiService, and trendInfo: EntryTrendInfo) {
        self.entryTrendInfo = trendInfo
        super.init(with: apiService)
    }
    
    override func createObservable(page: Int) -> Observable<ProductListResult> {
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