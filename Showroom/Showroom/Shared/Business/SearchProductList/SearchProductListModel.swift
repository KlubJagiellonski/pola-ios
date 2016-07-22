import Foundation

final class SearchProductListModel: ProductListModel {
    private(set) var entrySearchInfo: EntrySearchInfo
    var query: String
    
    init(with searchEntryData: EntrySearchInfo, and apiService: ApiService) {
        self.entrySearchInfo = searchEntryData
        self.query = searchEntryData.query
        super.init(with: apiService)
    }
    
    func update(with data: EntrySearchInfo) {
        self.entrySearchInfo = data
        self.query = data.query
    }
}