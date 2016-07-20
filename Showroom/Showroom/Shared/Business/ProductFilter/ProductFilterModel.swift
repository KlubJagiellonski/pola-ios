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
    
    func resetTempFilter() {
        state.tempFilter.value = nil
    }
    
    func updateSelectedFilters(ids: [ObjectId], forOption filterOption: FilterOption) {
        if let tempFilter = state.tempFilter.value {
            state.currentFilter.value = tempFilter
        } else {
            switch filterOption {
            case .Sort:
                state.currentFilter.value.selectedSortOptionId = ids[0]
            case .Color:
                state.currentFilter.value.selectedColorIds = ids
            case .Size:
                state.currentFilter.value.selectedSizeIds = ids
            case .Category:
                state.currentFilter.value.selectedCategoryIds = ids
            case .Brand:
                state.currentFilter.value.selectedBrandIds = ids
            }
        }
        
        refreshFilter()
    }
    
    func updateTempSelectedFilters(selectedIds: [ObjectId], forOption filterOption: FilterOption) {
        var ids = selectedIds
        if let rootIndex = ids.indexOf(Constants.rootCategoryId) {
            ids.removeAtIndex(rootIndex)
        }
        var tempFilter = state.tempFilter.value ?? state.currentFilter.value
        switch filterOption {
        case .Sort:
            tempFilter.selectedSortOptionId = ids[0]
        case .Color:
            tempFilter.selectedColorIds = ids
        case .Size:
            tempFilter.selectedSizeIds = ids
        case .Category:
            tempFilter.selectedCategoryIds = ids
        case .Brand:
            tempFilter.selectedBrandIds = ids
        }
        state.tempFilter.value = tempFilter
        
        refreshTempFilter()
    }
    
    func createFilterInfo(forOption filterOption: FilterOption) -> FilterInfo {
        return createFilterInfo(forOption: filterOption, forFilter: state.currentFilter.value)
    }
    
    func createTempFilterInfo(forOption filterOption: FilterOption) -> FilterInfo? {
        guard state.tempFilter.value != nil else { return nil }
        return createFilterInfo(forOption: filterOption, forFilter: state.tempFilter.value!)
    }
    
    private func createFilterInfo(forOption filterOption: FilterOption, forFilter filter: Filter) -> FilterInfo {
        var filterItems: [FilterItem] = []
        var selectedFilterItemsIds: [Int] = []
        var defaultItemId: Int?
        var mode: FilterDetailsMode!
        var title: String!
        
        switch filterOption {
        case .Sort:
            filterItems = filter.sortOptions.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, type: .Default, inset: .Default)
            }
            selectedFilterItemsIds.append(filter.selectedSortOptionId)
            mode = .SingleChoice
            title = tr(.ProductListFilterRowSort)
            defaultItemId = filter.defaultSortOptionId
        case .Color:
            filterItems = filter.colors.map { option in
                let imageInfo = FilterImageInfo(type: option.type, value: option.value)
                return FilterItem(id: option.id, name: option.name, imageInfo: imageInfo, type: .Default, inset: .Default)
            }
            selectedFilterItemsIds.appendContentsOf(filter.selectedColorIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowColor)
        case .Size:
            filterItems = filter.sizes.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, type: .Default, inset: .Default)
            }
            selectedFilterItemsIds.appendContentsOf(filter.selectedSizeIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowSize)
        case .Category:
            filterItems.append(FilterItem(id: Constants.rootCategoryId, name: tr(.ProductListFilterAllCategories), imageInfo: nil, type: .Bold, inset: .Default))
            for category in filter.categories {
                filterItems.appendContentsOf(createFilterItems(forCategory: category))
            }
            if let selectedCategoryId = filter.selectedCategoryIds.last {
                selectedFilterItemsIds.append(selectedCategoryId)
            }
            mode = .Tree
            title = tr(.ProductListFilterRowCategory)
        case .Brand:
            filterItems = filter.brands!.map { option in
                return FilterItem(id: option.id, name: option.name, imageInfo: nil, type: .Default, inset: .Default)
            }
            
            selectedFilterItemsIds.appendContentsOf(filter.selectedBrandIds)
            mode = .MultiChoice
            title = tr(.ProductListFilterRowBrand)
        }
        
        return FilterInfo(filterItems: filterItems, selectedFilterItemIds: selectedFilterItemsIds, defaultFilterId: defaultItemId, mode: mode, title: title)
    }
    
    private func refreshFilter() {
        //todo
    }
    
    private func refreshTempFilter() {
        state.tempFilter.value = mockedSubTreeFilter
    }
    
    private func createFilterItems(forCategory category: FilterCategory) -> [FilterItem] {
        var filterItems: [FilterItem] = []
        if let branches = category.branches {
            filterItems.append(FilterItem(id: category.id, name: category.name, imageInfo: nil, type: .Bold, inset: .Default))
            for branch in branches {
                filterItems.appendContentsOf(createFilterItems(forCategory: branch))
            }
        } else {
            filterItems.append(FilterItem(id: category.id, name: category.name, imageInfo: nil, type: .Default, inset: .Big))
        }
        return filterItems
    }
}

final class ProductFilterModelState {
    private(set) var currentFilter: Variable<Filter>
    private(set) var tempFilter: Variable<Filter?> = Variable(nil)
    private(set) var refreshing = Variable(false)
    
    init(with filter: Filter) {
        currentFilter = Variable(filter)
    }
}

struct FilterInfo {
    let filterItems: [FilterItem]
    let selectedFilterItemIds: [Int]
    let defaultFilterId: Int?
    let mode: FilterDetailsMode
    let title: String
}

enum FilterDetailsMode {
    case SingleChoice, MultiChoice, Tree
}

struct FilterItem {
    let id: ObjectId
    let name: String
    let imageInfo: FilterImageInfo?
    let type: FilterItemType
    let inset: FilterItemInset
}

struct FilterImageInfo {
    let type: FilterColorType
    let value: String
}

enum FilterItemType {
    case Default, Bold
}

enum FilterItemInset {
    case Default, Big
}

//todo remove 

extension ProductFilterModel {
    var mockedSubTreeFilter: Filter {
        let sortOptions = [
            FilterSortOption(id: 1, name: "Wybór projektanta"),
            FilterSortOption(id: 2, name: "Nowości"),
            FilterSortOption(id: 3, name: "Cena od najniższej"),
            FilterSortOption(id: 4, name: "Cena od najwyższej")
        ]
        let selectedSortOption = 1
        
        let balerinkiCategories = [
            FilterCategory(id: 3, name: "Czarne", branches: nil),
            FilterCategory(id: 4, name: "Czerwone", branches: nil)
        ]
        let shoesCategories = [
            FilterCategory(id: 2, name: "Balerinki", branches: balerinkiCategories),
        ]
        let filterCategories = [
            FilterCategory(id: 1, name: "Buty", branches: shoesCategories),
            ]
        let selectedFilterCategory = [1, 2]
        
        let sizes = [
            FilterSize(id: 1, name: "onesize"),
            FilterSize(id: 2, name: "M"),
            FilterSize(id: 3, name: "36"),
            FilterSize(id: 4, name: "38"),
            FilterSize(id: 5, name: "40"),
            FilterSize(id: 6, name: "XXS"),
            ]
        let colors = [
            FilterColor(id: 1, name: "Beżowy", type: .RGB, value: "FAFAFA"),
            FilterColor(id: 2, name: "Biały", type: .RGB, value: "FFFFFF"),
            FilterColor(id: 3, name: "Czarny", type: .RGB, value: "000000"),
            FilterColor(id: 4, name: "Pstrokaty", type: .Image, value: "https://placehold.it/50x50/888888/ffffff"),
            ]
        let selectedColors = [
            1
        ]
        
        let brands = [
            FilterBrand(id: 1, name: "10 DECOART"),
            FilterBrand(id: 2, name: "4LCK"),
            FilterBrand(id: 3, name: "9fashion Woman"),
            FilterBrand(id: 4, name: "A2"),
            FilterBrand(id: 5, name: "Afriq Password"),
            FilterBrand(id: 6, name: "Afunguard"),
            ]
        let selectedBrands = [1, 2, 3, 4, 5, 6]
        
        let mockedFilter = Filter(sortOptions: sortOptions, selectedSortOptionId: selectedSortOption, defaultSortOptionId: 3, categories: filterCategories, selectedCategoryIds: selectedFilterCategory, sizes: sizes, selectedSizeIds: [], colors: colors, selectedColorIds: selectedColors, priceRange: PriceRange(min: Money(amt: 0.0), max: Money(amt: 1000.0)), selectedPriceRange: nil, onlyDiscountsSelected: true, brands: brands, selectedBrandIds: selectedBrands)
        return mockedFilter
    }
}