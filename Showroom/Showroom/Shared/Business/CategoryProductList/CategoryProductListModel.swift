import Foundation

final class CategoryProductListModel: ProductListModel {
    private(set) var category: EntryCategory
    
    init(with category: EntryCategory, apiService: ApiService, emarsysService: EmarsysService, wishlistManager: WishlistManager) {
        self.category = category
        super.init(with: apiService, emarsysService: emarsysService, wishlistManager: wishlistManager, link: category.link, query: nil)
    }
    
    func update(with category: EntryCategory) {
        logInfo("Update with category: \(category)")
        self.category = category
        resetOnUpdate(withLink: category.link, query: nil)
    }
}