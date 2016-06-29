import Foundation

final class CategoryProductListModel: ProductListModel {
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init()
    }
}