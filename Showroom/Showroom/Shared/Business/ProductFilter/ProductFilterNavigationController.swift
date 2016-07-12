import Foundation
import UIKit

protocol ProductFilterNavigationControllerDelegate: class {
    func productFilterDidCancel(viewController: ProductFilterNavigationController)
}

class ProductFilterNavigationController: UINavigationController {
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
        viewControllers = [viewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCancel() {
        filterDelegate?.productFilterDidCancel(self)
    }
}
