import Foundation

final class SearchProductListModel: ProductListModel {
    var query: String
    
    init(withQuery query: String, and apiService: ApiService) {
        self.query = query
        super.init(with: apiService)
    }
}