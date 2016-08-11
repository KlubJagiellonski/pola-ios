import Foundation
import UIKit
import RxSwift

protocol ProductFilterNavigationControllerDelegate: class {
    func productFilter(viewController: ProductFilterNavigationController, wantsCancelWithAnimation animation: Bool)
    func productFilter(viewController: ProductFilterNavigationController, didChangedFilterWithProductListResult productListResult: ProductListResult?)
}

struct ProductFilterContext {
    let entryFilters: [Filter]
    let filters: [Filter]
    let fetchObservable: [Filter] -> Observable<ProductListResult>
}

class ProductFilterNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private let model: ProductFilterModel
    weak var filterDelegate: ProductFilterNavigationControllerDelegate?
    
    init(with resolver: DiResolver, and context: ProductFilterContext) {
        self.resolver = resolver
        self.model = resolver.resolve(ProductFilterModel.self, argument: context)
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhiteStyle()
     
        let viewController = resolver.resolve(ProductFilterViewController.self, argument: model)
        viewController.navigationItem.leftBarButtonItem = createBlueTextBarButtonItem(title: tr(.ProductListFilterCancel), target: self, action: #selector(ProductFilterNavigationController.didTapCancel))
        viewController.resetBackTitle()
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCancel() {
        filterDelegate?.productFilter(self, wantsCancelWithAnimation: true)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let showFilterEvent = event as? ShowFilterEvent {
            let filterInfo = model.createFilterInfo(forFilterId: showFilterEvent.filter.id)
            let viewController = resolver.resolve(FilterDetailsViewController.self, arguments:(model, filterInfo))
            viewController.resetBackTitle()
            pushViewController(viewController, animated: true)
            return true
        } else if let simpleEvent = event as? SimpleNavigationEvent {
            if simpleEvent.type == .ShowFilteredProducts {
                filterDelegate?.productFilter(self, didChangedFilterWithProductListResult: model.changedProductListResult)
                return true
            } else if simpleEvent.type == .Back {
                popViewControllerAnimated(true)
                return true
            }
        }
        return false
    }
}

extension ProductFilterNavigationController: ExtendedModalViewController {
    func forceCloseWithoutAnimation() {
        filterDelegate?.productFilter(self, wantsCancelWithAnimation: false)
    }
}