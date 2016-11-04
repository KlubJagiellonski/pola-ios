import Foundation

final class CategoryProductListModel: ProductListModel {
    private(set) var category: EntryCategory
    
    init(with category: EntryCategory, apiService: ApiService, wishlistManager: WishlistManager) {
        self.category = category
        super.init(with: apiService, wishlistManager: wishlistManager, link: category.link.absoluteOrRelativeString, query: nil)
    }
    
    func update(with category: EntryCategory) {
        logInfo("Update with category: \(category)")
        self.category = category
        resetOnUpdate(withLink: category.link.absoluteOrRelativeString, query: nil)
    }
}
