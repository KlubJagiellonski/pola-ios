import Foundation
import RxSwift

final class SearchProductListModel: ProductListModel {
    private(set) var entrySearchInfo: EntrySearchInfo
    
    init(with searchEntryData: EntrySearchInfo, apiService: ApiService, wishlistManager: WishlistManager) {
        self.entrySearchInfo = searchEntryData
        super.init(with: apiService, wishlistManager: wishlistManager, link: searchEntryData.link, query: entrySearchInfo.query)
    }
    
    func update(with data: EntrySearchInfo) {
        logInfo("Update with data: \(data)")
        self.entrySearchInfo = data
        resetOnUpdate(withLink: data.link, query: data.query)
    }
    
    override func createObservable(with paginationInfo: PaginationInfo, forFilters filters: [FilterId: [FilterObjectId]]?) -> Observable<ProductListResult> {
        if let query = query where paginationInfo.page == 1 {
            logAnalyticsEvent(AnalyticsEventId.Search(query))
        }
        return super.createObservable(with: paginationInfo, forFilters: filters)
    }
}
