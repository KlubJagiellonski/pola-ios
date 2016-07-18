import UIKit
import RxSwift

class TrendProductListViewController: UIViewController, ProductListViewControllerInterface, TrendProductListViewDelegate {
    let disposeBag = DisposeBag()
    let productListModel: ProductListModel
    var trendListModel: TrendProductListModel { return productListModel as! TrendProductListModel }
    var productListView: ProductListViewInterface { return castView }
    var castView: TrendProductListView { return view as! TrendProductListView }
    
    init(with resolver: DiResolver) {
        productListModel = resolver.resolve(TrendProductListModel.self)
        super.init(nibName: nil, bundle: nil)
        
        title = "New Neutrals"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = TrendProductListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        
        configureProductList()
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return nil // not needed in trend
    }
    
    func pageWasFetched(result productListResult: ProductListResult, page: Int) {
        if page == 0 {
            castView.updateTrendInfo("", description: trendListModel.description)
        }
    }
    
    func filterButtonEnableStateChanged(toState enabled: Bool) { }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}