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
    let totalProductsAmount: Int
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
        logInfo("Did tap cancel")
        filterDelegate?.productFilter(self, wantsCancelWithAnimation: true)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let showFilterEvent = event as? ShowFilterEvent {
            logInfo("Show filter details")
            guard let filterInfo = model.createFilterInfo(forFilterId: showFilterEvent.filter.id) else {
                logError("Failed to show filter details, filter: \(showFilterEvent.filter)")
                return true
            }
            let viewController = resolver.resolve(FilterDetailsViewController.self, arguments:(model, filterInfo))
            viewController.resetBackTitle()
            pushViewController(viewController, animated: true)
            return true
        } else if let simpleEvent = event as? SimpleNavigationEvent {
            if simpleEvent.type == .ShowFilteredProducts {
                logInfo("Show filter products")
                filterDelegate?.productFilter(self, didChangedFilterWithProductListResult: model.changedProductListResult)
                return true
            } else if simpleEvent.type == .Back {
                logInfo("Back")
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