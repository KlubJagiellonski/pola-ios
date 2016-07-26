import Foundation

final class CategoryProductListModel: ProductListModel {
    private(set) var category: EntryCategory
    
    init(with category: EntryCategory, apiService: ApiService, wishlistManager: WishlistManager) {
        self.category = category
        super.init(with: apiService, wishlistManager: wishlistManager)
    }
    
    func update(with category: EntryCategory) {
        self.category = category
    }
}