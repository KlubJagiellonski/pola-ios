import Foundation
import UIKit
import RxSwift

class SearchProductListViewController: UIViewController, ProductListViewControllerInterface, SearchProductListViewDelegate {
    typealias EntryData = EntrySearchInfo
    
    var disposeBag = DisposeBag()
    private let resolver: DiResolver
    let productListModel: ProductListModel
    private var model: SearchProductListModel { return productListModel as! SearchProductListModel }
    var productListView: ProductListViewInterface { return castView }
    private var castView: SearchProductListView { return view as! SearchProductListView }
    
    init(with resolver: DiResolver, entryData: EntrySearchInfo) {
        self.resolver = resolver
        productListModel = resolver.resolve(SearchProductListModel.self, argument: entryData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SearchProductListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.queryText = model.query
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.titleView = castView.searchContainerView
        
        configureProductList()
        fetchFirstPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.SearchProducts)
    }
    
    func updateData(with data: EntrySearchInfo) {
        disposeBag = DisposeBag()
        model.update(with: data)
        castView.queryText = model.query
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
    
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) { }
    
    func filterButtonEnableStateChanged(toState enabled: Bool) {
        castView.searchEnabled = enabled
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
    
    func searchProductList(view: SearchProductListView, didTapSearchWithQuery query: String) {
        model.query = query
        fetchFirstPage()
    }
    
    func searchProductListDidCancelEditing(view: SearchProductListView) {
        castView.queryText = model.query
    }
}

extension SearchProductListViewController: ProductFilterNavigationControllerDelegate {
    func productFilter(viewController: ProductFilterNavigationController, wantsCancelWithAnimation animation: Bool) {
        dismissViewControllerAnimated(animation, completion: nil)
    }
    
    func productFilter(viewController: ProductFilterNavigationController, didChangedFilterWithProductListResult productListResult: ProductListResult?) {
        dismissViewControllerAnimated(true, completion: nil)
        if productListResult != nil {
            didChangeFilter(withResult: productListResult!)
        }
    }
}