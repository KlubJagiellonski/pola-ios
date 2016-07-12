import Foundation
import UIKit

class ProductFilterViewController: UIViewController, ProductFilterViewDelegate {
    private let model: ProductFilterModel
    private var castView: ProductFilterView { return view as! ProductFilterView }
    
    init(with model: ProductFilterModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        title = tr(.ProductListFilterTitle)
        navigationItem.rightBarButtonItem = createBlueTextBarButtonItem(title: tr(.ProductListFilterClear), target: self, action: #selector(ProductFilterViewController.didTapClear))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductFilterView(with: self.model.state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    func didTapClear() {
        model.clearChanges()
    }
    
    // MARK:- ProductFilterViewDelegate
    
    func productFilterDidTapAccept(view: ProductFilterView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowFilteredProducts))
    }
    
    func productFilter(view: ProductFilterView, didSelectItem filterOption: FilterOption) {
        sendNavigationEvent(ShowFilterOptionEvent(filterOption: filterOption))
    }
    
    func productFilter(view: ProductFilterView, didChangePriceRange priceRange: PriceRange) {
        model.update(with: priceRange)
    }
    
    func productFilter(view: ProductFilterView, didChangePriceDiscount priceDiscountSelected: Bool) {
        model.update(withPriceDiscount: priceDiscountSelected)
    }
}