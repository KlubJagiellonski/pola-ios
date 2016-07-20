import Foundation

struct Filter {
    let sortOptions: [FilterSortOption]
    var selectedSortOptionId: ObjectId
    let defaultSortOptionId: ObjectId
    let categories: [FilterCategory]
    var selectedCategoryIds: [ObjectId]
    let sizes: [FilterSize]
    var selectedSizeIds: [ObjectId]
    let colors: [FilterColor]
    var selectedColorIds: [ObjectId]
    let priceRange: PriceRange
    var selectedPriceRange: PriceRange?
    var onlyDiscountsSelected: Bool
    let brands: [FilterBrand]?
    var selectedBrandIds: [ObjectId]
}

struct FilterSortOption {
    let id: ObjectId
    let name: String
}

struct FilterCategory {
    let id: ObjectId
    let name: String
    let branches: [FilterCategory]?
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