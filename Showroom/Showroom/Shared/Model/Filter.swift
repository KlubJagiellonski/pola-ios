import Foundation

struct Filter {
    let sortOptions: [FilterSortOption]
    var selectedSortOption: FilterSortOption
    let categories: [FilterCategory]
    var selectedCategory: FilterCategory?
    let sizes: [FilterSize]
    var selectedSizes: [FilterSize]?
    let colors: [FilterColor]
    var selectedColors: [FilterColor]?
    let priceRange: PriceRange
    var selectedPriceRange: PriceRange?
    var onlyDiscountsSelected: Bool
    let brands: [FilterBrand]?
    var selectedBrands: [FilterBrand]?
}

struct FilterSortOption {
    let id: ObjectId
    let name: String
}

struct FilterCategory {
    let id: ObjectId
    let name: String
    let hasChildCategories: Bool
}

struct FilterSize {
    let id: ObjectId
    let name: String
}

enum FilterColorType: String {
    case RGB = "RGB"
    case Image = "Image"
}

struct FilterColor {
    let id: ObjectId
    let name: String
    let type: FilterColorType
    let value: String
}

struct PriceRange {
    let min: Money
    let max: Money
}

struct FilterBrand {
    let id: ObjectId
    let name: String
}