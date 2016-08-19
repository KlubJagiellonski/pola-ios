import Foundation
import UIKit
import RxSwift

class BrandProductListViewController: UIViewController, ProductListViewControllerInterface, BrandProductListViewDelegate {
    typealias EntryData = EntryProductBrand
    
    private let resolver: DiResolver
    var disposeBag = DisposeBag()
    let productListModel: ProductListModel
    private var model: BrandProductListModel { return productListModel as! BrandProductListModel }
    var productListView: ProductListViewInterface { return castView }
    private var castView: BrandProductListView { return view as! BrandProductListView }
    
    init(with resolver: DiResolver, and brand: EntryProductBrand) {
        self.resolver = resolver
        productListModel = resolver.resolve(BrandProductListModel.self, argument: brand)
        super.init(nibName: nil, bundle: nil)
        
        title = brand.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BrandProductListView()
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
        logAnalyticsShowScreen(.Brand)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    func updateData(with entryProductBrand: EntryProductBrand) {
        guard entryProductBrand.id != model.productBrand.id else {
            logInfo("Tried to update same brand info view")
            return
        }
        title = entryProductBrand.name
        disposeBag = DisposeBag()
        model.update(with: entryProductBrand)
        fetchFirstPage()
    }
    
    func createFilterButton() -> UIBarButtonItem? {
        return UIBarButtonItem(image: UIImage(asset: .Ic_filter), style: .Plain, target: self, action: #selector(didTapFilterButton))
    }
    
    func didTapFilterButton() {
        logAnalyticsEvent(AnalyticsEventId.ListFilterIconClicked)
        
        guard let context = productListModel.createFilterContext() else {
            logError("Cannot create context, possible no filters")
            return
        }
        let viewController = resolver.resolve(ProductFilterNavigationController.self, argument: context)
        viewController.filterDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) {
        if let brand = productListResult.brand, let description = model.attributedDescription where pageIndex == 0 {
            title = brand.name
            castView.updateBrandInfo(brand.imageUrl, description: description)
        } else if pageIndex == 0 {
            logError("Didn't received brand info in result: \(productListResult)")
        }
    }
    
    // MARK:- BrandProductListViewDelegate
    
    func brandProductListDidTapHeader(view: BrandProductListView) {
        guard let brand = model.brand else { return }
        logAnalyticsEvent(AnalyticsEventId.ListBrandDetails(brand.id))
        let imageWidth = castView.headerImageWidth
        let lowResImageUrl = NSURL.createImageUrl(brand.imageUrl, width: imageWidth, height: nil)
        sendNavigationEvent(ShowBrandDescriptionEvent(brand: brand.appendLowResImageUrl(lowResImageUrl.absoluteString)))
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        fetchFirstPage()
    }
}

extension BrandProductListViewController: ProductFilterNavigationControllerDelegate {
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

