import Foundation
import UIKit

protocol ProductFilterNavigationControllerDelegate: class {
    func productFilterDidCancel(viewController: ProductFilterNavigationController)
}

class ProductFilterNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private let model: ProductFilterModel
    weak var filterDelegate: ProductFilterNavigationControllerDelegate?
    
    init(with resolver: DiResolver, and filter: Filter) {
        self.resolver = resolver
        self.model = resolver.resolve(ProductFilterModel.self, argument: filter)
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
        filterDelegate?.productFilterDidCancel(self)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let showFilterOptionEvent = event as? ShowFilterOptionEvent {
            let viewController = resolver.resolve(FilterDetailsViewController.self, arguments:(model, showFilterOptionEvent.filterOption))
            viewController.resetBackTitle()
            pushViewController(viewController, animated: true)
            return true
        } else if let simpleEvent = event as? SimpleNavigationEvent {
            if simpleEvent.type == .ShowFilteredProducts {
                //todo show filtered products
                return true
            } else if simpleEvent.type == .Back {
                popViewControllerAnimated(true)
                return true
            }
        }
        return false
    }
}
