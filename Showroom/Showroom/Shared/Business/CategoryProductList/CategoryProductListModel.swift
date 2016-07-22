import Foundation

final class CategoryProductListModel: ProductListModel {
    private(set) var category: EntryCategory
    
    init(with category: EntryCategory, and apiService: ApiService) {
        self.category = category
        super.init(with: apiService)
    }
    
    func update(with category: EntryCategory) {
        self.category = category
    }
}