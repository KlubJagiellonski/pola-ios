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
        logInfo("Did tap filter button")
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
        logInfo("Fetched page with index: \(pageIndex)")
        if let brand = productListResult.brand, let description = model.attributedDescription where pageIndex == 0 {
            title = brand.name
            castView.updateBrandInfo(with: brand, description: description)
        } else if pageIndex == 0 {
            logError("Didn't received brand info in result: \(productListResult)")
        }
    }
    
    // MARK:- BrandProductListViewDelegate
    
    func brandProductListDidTapBrandInfo(view: BrandProductListView) {
        logInfo("Brand product list did tap header")
        guard let brand = model.brand else { return }
        logAnalyticsEvent(AnalyticsEventId.ListBrandDetails(brand.id, brand.name))
        let imageWidth = castView.headerImageWidth
        let lowResImageUrl = NSURL.createImageUrl(brand.imageUrl, width: imageWidth, height: nil)
        sendNavigationEvent(ShowBrandDescriptionEvent(brand: brand.appendLowResImageUrl(lowResImageUrl.absoluteString)))
    }
    
    func brandProductList(view: BrandProductListView, didTapVideoAtIndex index: Int) {
        guard let video = model.brand?.videos[safe: index] else {
            logError("Cannot get video for index \(index) with brand details \(model.brand)")
            return
        }
        
        let imageTag = castView.videoImageTag(forIndex: index)
        sendNavigationEvent(ShowPromoSlideshowEvent(slideshowId: video.id, transitionImageTag: imageTag))
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("View switcher did tap retry")
        fetchFirstPage()
    }
}

extension BrandProductListViewController: ProductFilterNavigationControllerDelegate {
    func productFilter(viewController: ProductFilterNavigationController, wantsCancelWithAnimation animation: Bool) {
        logInfo("Product filter wants cancel, with animation: \(animation)")
        dismissViewControllerAnimated(animation, completion: nil)
    }
    
    func productFilter(viewController: ProductFilterNavigationController, didChangedFilterWithProductListResult productListResult: ProductListResult?) {
        logInfo("Product filter did changed filter")
        dismissViewControllerAnimated(true, completion: nil)
        if productListResult != nil {
            didChangeFilter(withResult: productListResult!)
        }
    }
}
