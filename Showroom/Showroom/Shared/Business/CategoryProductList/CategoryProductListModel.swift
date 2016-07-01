import Foundation

final class CategoryProductListModel: ProductListModel {
    let category: Category
    
    init(with category: Category, and apiService: ApiService) {
        self.category = category
        super.init(with: apiService)
    }
}