import Foundation
import RxSwift

final class ProductFilterModel {
    private let disposeBag = DisposeBag()
    private let api: ApiService
    private let context: ProductFilterContext
    private(set) var changedProductListResult: ProductListResult?
    let state: ProductFilterModelState
    
    init(with context: ProductFilterContext, and api: ApiService) {
        self.api = api
        self.context = context
        state = ProductFilterModelState(with: context.filters, totalProductsAmount: context.totalProductsAmount)
    }
    
    func update(with valueRange: ValueRange, forFilterId filterId: FilterId) {
        update(withData: [valueRange.min, valueRange.max], forFilterId: filterId)
    }
    
    func update(withSelected selected: Bool, forFilterId filterId: FilterId) {
        let data: [Int] = selected ? [1] : []
        update(withData: data, forFilterId: filterId)
    }
    
    func update(withData data: [FilterObjectId], forFilterId filterId: FilterId) {
        logInfo("Updating filters for data \(data) filterId \(filterId)")
        guard let filterIndex = state.currentFilters.value.indexOf({ $0.id == filterId }) else {
            logError("Could not update filter, filter not found for id \(filterId), filters \(state.currentFilters)")
            return
        }
        refreshFilter() {
            if let tempFilter = state.tempFilter.value {
                updateTemp(withData: data, forFilterId: filterId)
                state.currentFilters.value[filterIndex] = tempFilter
            } else {
                state.currentFilters.value[filterIndex].data = data
            }
        }
    }
    
    func updateTemp(withData data: [FilterObjectId], forFilterId filterId: FilterId) {
        var filters = state.currentFilters.value
        guard let filterIndex = filters.indexOf({ $0.id == filterId }) else {
            logError("Could not update temp filter, filter not found for id \(filterId), filters \(filters)")
            return
        }
        filters[filterIndex].data = data
        refreshTempFilter(filters, forFilterId: filterId)
    }
    
    func clearChanges() {
        logInfo("Clearing changes")
        refreshFilter() {
            state.currentFilters.value = context.entryFilters
        }
    }
    
    func resetTempFilter() {
        logInfo("Reseting temp filter")
        state.tempFilter.value = nil
    }
    
    func createFilterInfo(forFilterId filterId: FilterId) -> FilterInfo? {
        logInfo("Creating filter info for id \(filterId)")
        guard let filter = state.currentFilters.value.find({ $0.id == filterId }) else {
            logError("Cannot create filter, filter with specified id \(filterId) doesn't exist in \(state.currentFilters)")
            return nil
        }
        return createFilterInfo(forFilter: filter)
    }
    
    func createTempFilterInfo(forFilterId filterId: FilterId) -> FilterInfo? {
        logInfo("Creating temp filter info for id \(filterId)")
        guard state.tempFilter.value != nil else {
            logInfo("Cannot create filter info. Temp filter not exist")
            return nil
        }
        return createFilterInfo(forFilter: state.tempFilter.value!)
    }
    
    private func createFilterInfo(forFilter filter: Filter) -> FilterInfo? {
        var filterItems: [FilterItem] = []
        var selectedFilterItemsIds: [FilterObjectId] = []
        var mode: FilterDetailsMode!
        
        logInfo("Creating filter info for filter \(filter)")
        
        switch filter.type {
        case .Choice:
            filterItems = filter.choices!.map { choice in
                var imageInfo: FilterImageInfo?
                if let colorType = choice.colorType, let colorValue = choice.colorValue {
                    imageInfo = FilterImageInfo(type: colorType, value: colorValue)
                }
                return FilterItem(id: choice.id, name: choice.name, imageInfo: imageInfo, type: .Default, inset: .Default)
            }
            selectedFilterItemsIds.appendContentsOf(filter.data)
            mode = filter.multiple ? .MultiChoice : .SingleChoice
        case .Tree:
            for branch in filter.branches! {
                filterItems.appendContentsOf(createFilterItems(forFilterBranch: branch))
            }
            selectedFilterItemsIds = filter.data
            mode = .Tree
        case .Unknown, .Range, .Select:
            logError("Cannot create filterInfo for filter \(filter)")
            return nil
        }
        
        return FilterInfo(id: filter.id, filterItems: filterItems, selectedFilterItemIds: selectedFilterItemsIds, defaultFilterId: filter.defaultId, mode: mode, title: filter.label, indexable: filter.indexable)
    }
    
    private func refreshFilter(@noescape refreshFilterBlock: () -> ()) {
        let oldFilters = state.currentFilters.value
        
        refreshFilterBlock()
        
        logInfo("Refresing filter")
        state.viewState.value = .Refreshing
        context.fetchObservable(state.currentFilters.value)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self](event: Event<ProductListResult>) in
                guard let `self` = self else { return }
                
                self.state.viewState.value = .Default
                
                switch event {
                case .Next(let result):
                    logInfo("Refreshing filter success with result \(result.filters)")
                    self.changedProductListResult = result
                    self.state.totalProductsAmount.value = result.totalResults
                case .Error(let error):
                    self.state.viewState.value = .Error
                    self.state.currentFilters.value = oldFilters
                    logInfo("Error during refreshing filter \(error)")
                default: break
                }
        }.addDisposableTo(disposeBag)
    }
    
    private func refreshTempFilter(currentFilters: [Filter], forFilterId filterId: FilterId) {
        state.tempViewState.value = .Refreshing
        
        context.fetchObservable(currentFilters)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self](event: Event<ProductListResult>) in
                guard let `self` = self else { return }
        
                self.state.tempViewState.value = .Default
                
                switch event {
                case .Next(let result):
                    logInfo("Fetched temp filter \(result)")
                    self.state.tempFilter.value = result.filters?.find { $0.id == filterId }
                case .Error(let error):
                    logInfo("Error during refreshing temp filter \(error)")
                    self.state.tempViewState.value = .Error
                default: break
                }
            }.addDisposableTo(disposeBag)
    }
    
    private func createFilterItems(forFilterBranch filterBranch: FilterBranch) -> [FilterItem] {
        var filterItems: [FilterItem] = []
        if filterBranch.branches.count > 0 {
            filterItems.append(FilterItem(id: filterBranch.id, name: filterBranch.label, imageInfo: nil, type: .Bold, inset: .Default))
            for branch in filterBranch.branches {
                filterItems.appendContentsOf(createFilterItems(forFilterBranch: branch))
            }
        } else {
            filterItems.append(FilterItem(id: filterBranch.id, name: filterBranch.label, imageInfo: nil, type: .Default, inset: .Big))
        }
        return filterItems
    }
}

enum ProductFilterViewState {
    case Default
    case Refreshing
    case Error
}

final class ProductFilterModelState {
    private(set) var currentFilters: Variable<[Filter]>
    private(set) var tempFilter: Variable<Filter?> = Variable(nil)
    private(set) var viewState = Variable(ProductFilterViewState.Default)
    private(set) var tempViewState = Variable(ProductFilterViewState.Default)
    private(set) var totalProductsAmount: Variable<Int>
    
    init(with filters: [Filter], totalProductsAmount: Int) {
        self.currentFilters = Variable(filters)
        self.totalProductsAmount = Variable(totalProductsAmount)
    }
}

struct FilterInfo {
    let id: FilterId
    let filterItems: [FilterItem]
    let selectedFilterItemIds: [FilterObjectId]
    let defaultFilterId: FilterObjectId?
    let mode: FilterDetailsMode
    let title: String
    let indexable: Bool
}

enum FilterDetailsMode {
    case SingleChoice, MultiChoice, Tree
}

struct FilterItem {
    let id: FilterObjectId
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