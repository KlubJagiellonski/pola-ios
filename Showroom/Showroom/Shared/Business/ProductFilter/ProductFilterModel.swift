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
    
    private func refreshFilter() {
        //todo api call
    }
}

final class ProductFilterModelState {
    var currentFilter: Variable<Filter>
    
    init(with filter: Filter) {
        currentFilter = Variable(filter)
    }
}