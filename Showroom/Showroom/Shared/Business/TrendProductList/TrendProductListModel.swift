import Foundation
import CocoaMarkdown
import RxSwift

final class TrendProductListModel: ProductListModel {
    let entryTrendInfo: EntryTrendInfo
    private(set) var trendInfo: TrendInfo?
    
    var attributedDescription: NSAttributedString?
    
    init(with apiService: ApiService, and trendInfo: EntryTrendInfo) {
        self.entryTrendInfo = trendInfo
        super.init(with: apiService)
    }
    
    override func createObservable() -> Observable<ProductListResult> {
        return apiService.fetchTrend(entryTrendInfo.slug)
            .doOnNext { [weak self] result in
                self?.attributedDescription = result.trendInfo!.description.markdownToAttributedString()
                self?.trendInfo = result.trendInfo
        }
    }
}