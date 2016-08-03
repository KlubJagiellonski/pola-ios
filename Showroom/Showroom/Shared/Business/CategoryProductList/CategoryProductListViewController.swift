import Foundation
import UIKit
import RxSwift

class CategoryProductListViewController: UIViewController, ProductListViewControllerInterface, CategoryProductListViewDelegate {
    typealias EntryData = EntryCategory
    
    var disposeBag = DisposeBag()
    let productListModel: ProductListModel
    private var model: CategoryProductListModel { return productListModel as! CategoryProductListModel }
    var productListView: ProductListViewInterface { return castView }
    private var castView: CategoryProductListView { return view as! CategoryProductListView }
    private let resolver: DiResolver
    
    init(withResolver resolver: DiResolver, category: EntryCategory) {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.ProductList)
    }
    
    func updateData(with entryCategory: EntryCategory) {
        title = entryCategory.name
        disposeBag = DisposeBag()
        model.update(with: entryCategory)
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
    }
    
    func didTapFilterButton() {
        guard let context = productListModel.createFilterContext() else {
            logError("Cannot create context, possible no filters")
            return
        }
        let viewController = resolver.resolve(ProductFilterNavigationController.self, argument: context)
        viewController.filterDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) {
        //todo set title
    }
    
    func filterButtonEnableStateChanged(toState enabled: Bool) { }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}

extension CategoryProductListViewController: ProductFilterNavigationControllerDelegate {
    func productFilter(viewController: ProductFilterNavigationController, wantsCancelWithAnimation animation: Bool) {
        dismissViewControllerAnimated(animation, completion: nil)
    }
    
    func productFilter(viewController: ProductFilterNavigationController, didChangedFilterWithProductListResult productListResult: ProductListResult) {
        dismissViewControllerAnimated(true, completion: nil)
        didChangeFilter(withResult: productListResult)
    }
}