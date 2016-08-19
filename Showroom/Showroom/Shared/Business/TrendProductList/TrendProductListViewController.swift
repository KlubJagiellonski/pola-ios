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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Trend)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    func updateData(with data: EntryTrendInfo) {
        guard data.slug != model.entryTrendInfo.slug else {
            logInfo("Tried to update same trend info view")
            return
        }
        title = data.name
        disposeBag = DisposeBag()
        model.update(with: data)
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return nil // not needed in trend
    }
    
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) {
        if let trendInfo = productListResult.trendInfo, let description = model.attributedDescription where pageIndex == 0 {
            title = trendInfo.name
            castView.updateTrendInfo(trendInfo.imageInfo, description: description)
        } else if pageIndex == 0 {
            logError("Didn't received trend info in result: \(productListResult)")
        }
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}