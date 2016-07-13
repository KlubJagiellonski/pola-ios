import Foundation
import RxSwift

final class ProductFilterModel {
    private let api: ApiService
    private let initialFilter: Filter
    let state: ProductFilterModelState
    
    init(with filter: Filter, and api: ApiService) {
        self.api = api
        self.initialFilter = filter
        state = ProductFilterModelState(with: filter)
    }
    
    func update(with priceRange: PriceRange) {
        state.currentFilter.value.selectedPriceRange = priceRange
        refreshFilter()
    }
    
    func update(withPriceDiscount priceDiscount: Bool) {
        state.currentFilter.value.onlyDiscountsSelected = priceDiscount
        refreshFilter()
    }
    
    func clearChanges() {
        state.currentFilter.value = initialFilter
        refreshFilter()
    }
    
    func updateSelectedFilters(ids: [ObjectId], forOption filterOption: FilterOption) {
        switch filterOption {
        case .Sort:
            state.currentFilter.value.selectedSortOptionId = ids[0]
        case .Color:
            state.currentFilter.value.selectedColorIds = ids
        case .Size:
            state.currentFilter.value.selectedSizeIds = ids
        case .Category:
            state.currentFilter.value.selectedCategoryId = ids.first
        case .Brand:
            state.currentFilter.value.selectedBrandIds = ids
        }
        
        refreshFilter()
    }
    
    func createFilterInfo(forOption filterOption: FilterOption) -> FilterInfo {
        var filterItems: [FilterItem] = []
        var selectedFilterItemsIds: [Int] = []
        var mode: FilterDetailsMode!
        var title: String!
        
        let filter = state.currentFilter.value
        switch filterOption {
        case .Sort:
            filterItems = filter.sortOptions.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, goToEnabled: false)
            }
            selectedFilterItemsIds.append(filter.selectedSortOptionId)
            mode = .SingleChoice
            title = tr(.ProductListFilterRowSort)
        case .Color:
            filterItems = filter.colors.map { option in
                let imageInfo = FilterImageInfo(type: option.type, value: option.value)
                return FilterItem(id: option.id, name: option.name, imageInfo: imageInfo, goToEnabled: false)
            }
            selectedFilterItemsIds.appendContentsOf(filter.selectedColorIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowColor)
        case .Size:
            filterItems = filter.sizes.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, goToEnabled: false)
            }
            selectedFilterItemsIds.appendContentsOf(filter.selectedSizeIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowSize)
        case .Category:
            filterItems = filter.categories.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, goToEnabled: option.hasChildCategories)
            }
            if let categoryId = filter.selectedCategoryId {
                selectedFilterItemsIds.append(categoryId)
            }
            mode = .SingleChoice
            title = tr(.ProductListFilterRowCategory)
        case .Brand:
            filterItems = filter.brands!.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, goToEnabled: false)
            }
            
            selectedFilterItemsIds.appendContentsOf(filter.selectedBrandIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowBrand)
        }
        
        return FilterInfo(filterItems: filterItems, selectedFilterItemIds: selectedFilterItemsIds, mode: mode, title: title)
    }
    
    private func refreshFilter() {
        // todo api call
    }
}

final class ProductFilterModelState {
    var currentFilter: Variable<Filter>
    
    init(with filter: Filter) {
        currentFilter = Variable(filter)
    }
}

struct FilterInfo {
    let filterItems: [FilterItem]
    let selectedFilterItemIds: [Int]
    let mode: FilterDetailsMode
    let title: String
}

enum FilterDetailsMode {
    case SingleChoice, MultiChoice
}

struct FilterItem {
    let id: ObjectId
    let name: String
    let imageInfo: FilterImageInfo?
    let goToEnabled: Bool
}

struct FilterImageInfo {
    let type: FilterColorType
    let value: String
}