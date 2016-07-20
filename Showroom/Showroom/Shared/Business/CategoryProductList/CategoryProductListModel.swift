import Foundation

final class CategoryProductListModel: ProductListModel {
    let category: EntryCategory
    
    init(with category: EntryCategory, and apiService: ApiService) {
        self.category = category
        super.init(with: apiService)
    }
}