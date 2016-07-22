import UIKit
import RxSwift

class TrendProductListViewController: UIViewController, ProductListViewControllerInterface, TrendProductListViewDelegate {
    typealias EntryData = EntryTrendInfo
    
    var disposeBag = DisposeBag()
    let productListModel: ProductListModel
    var model: TrendProductListModel { return productListModel as! TrendProductListModel }
    var productListView: ProductListViewInterface { return castView }
    var castView: TrendProductListView { return view as! TrendProductListView }
    
    init(with resolver: DiResolver, and info: EntryTrendInfo) {
        productListModel = resolver.resolve(TrendProductListModel.self, argument: info)
        super.init(nibName: nil, bundle: nil)
        
        title = info.name
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
    
    func updateData(with data: EntryTrendInfo) {
        title = data.name
        disposeBag = DisposeBag()
        model.update(with: data)
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return nil // not needed in trend
    }
    
    func pageWasFetched(result productListResult: ProductListResult, page: Int) {
        guard let trendInfo = productListResult.trendInfo else {
            logError("Didn't received trend info in result: \(productListResult)")
            return
        }
        title = trendInfo.name
        castView.updateTrendInfo(trendInfo.imageUrl, description: model.attributedDescription!)
    }
    
    func filterButtonEnableStateChanged(toState enabled: Bool) { }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}