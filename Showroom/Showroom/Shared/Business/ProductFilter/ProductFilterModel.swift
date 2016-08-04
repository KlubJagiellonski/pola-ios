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
        state = ProductFilterModelState(with: context.filters)
    }
    
    func update(with valueRange: ValueRange, forFilterId filterId: FilterId) {
        update(withData: [valueRange.min, valueRange.max], forFilterId: filterId)
    }
    
    func update(withSelected selected: Bool, forFilterId filterId: FilterId) {
        update(withData: [selected ? 1 : 0], forFilterId: filterId)
    }
    
    func update(withData data: [FilterObjectId], forFilterId filterId: FilterId) {
        guard let filterIndex = state.currentFilters.value.indexOf({ $0.id == filterId }) else { return }
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
        guard let filterIndex = filters.indexOf({ $0.id == filterId }) else { return }
        filters[filterIndex].data = data
        refreshTempFilter(filters, forFilterId: filterId)
    }
    
    func clearChanges() {
        refreshFilter() {
            state.currentFilters.value = context.filters
        }
    }
    
    func resetTempFilter() {
        state.tempFilter.value = nil
    }
    
    func createFilterInfo(forFilterId filterId: FilterId) -> FilterInfo {
        let filter = state.currentFilters.value.find({ $0.id == filterId })!
        return createFilterInfo(forFilter: filter)
    }
    
    func createTempFilterInfo(forFilterId filterId: FilterId) -> FilterInfo? {
        guard state.tempFilter.value != nil else { return nil }
        return createFilterInfo(forFilter: state.tempFilter.value!)
    }
    
    private func createFilterInfo(forFilter filter: Filter) -> FilterInfo {
        var filterItems: [FilterItem] = []
        var selectedFilterItemsIds: [FilterObjectId] = []
        var mode: FilterDetailsMode!
        
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
        case .Unknown:
            logError("Cannot create filterInfo for filter \(filter)")
        case .Range:
            fallthrough
        case .Select:
            fatalError("Cannot create filterInfo for filter \(filter)")
        }
        
        return FilterInfo(id: filter.id, filterItems: filterItems, selectedFilterItemIds: selectedFilterItemsIds, defaultFilterId: filter.defaultId, mode: mode, title: filter.label)
    }
    
    private func refreshFilter(@noescape refreshFilterBlock: () -> ()) {
        let oldFilters = state.currentFilters.value
        
        refreshFilterBlock()
        
        state.viewState.value = .Refreshing
        context.fetchObservable(state.currentFilters.value)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self](event: Event<ProductListResult>) in
                guard let `self` = self else { return }
                
                self.state.viewState.value = .Default
                
                switch event {
                case .Next(let result):
                    self.changedProductListResult = result
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
    
    init(with filters: [Filter]) {
        currentFilters = Variable(filters)
    }
}

struct FilterInfo {
    let id: FilterId
    let filterItems: [FilterItem]
    let selectedFilterItemIds: [FilterObjectId]
    let defaultFilterId: FilterObjectId?
    let mode: FilterDetailsMode
    let title: String
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