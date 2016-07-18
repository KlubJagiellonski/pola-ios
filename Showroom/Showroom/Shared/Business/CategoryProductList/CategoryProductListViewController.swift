import Foundation
import UIKit
import RxSwift

class CategoryProductListViewController: UIViewController, ProductListViewControllerInterface, CategoryProductListViewDelegate {
    let disposeBag = DisposeBag()
    let productListModel: ProductListModel
    private var model: CategoryProductListModel { return productListModel as! CategoryProductListModel }
    var productListView: ProductListViewInterface { return castView }
    private var castView: CategoryProductListView { return view as! CategoryProductListView }
    private let resolver: DiResolver
    
    init(withResolver resolver: DiResolver, category: Category) {
        self.resolver = resolver
        productListModel = resolver.resolve(CategoryProductListModel.self, argument: category)
        super.init(nibName: nil, bundle: nil)
        
        title = model.category.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CategoryProductListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        
        configureProductList()
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
    }
    
    func didTapFilterButton() {
        let viewController = resolver.resolve(ProductFilterNavigationController.self, argument: mockedFilter)
        viewController.filterDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func pageWasFetched(result productListResult: ProductListResult, page: Int) {}
    
    func filterButtonEnableStateChanged(toState enabled: Bool) { }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}

extension CategoryProductListViewController: ProductFilterNavigationControllerDelegate {}