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
    
    private lazy var onboardingActionAnimator: InAppOnboardingActionAnimator = { [unowned self] in
        return InAppOnboardingActionAnimator(parentViewHeight: self.castView.bounds.height)
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showInAppWishlistOnboardingIfNeeded()
    }
    
    func updateData(with data: EntrySearchInfo) {
        logInfo("Update data with data: \(data)")
        disposeBag = DisposeBag()
        model.update(with: data)
        castView.queryText = model.query
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
    
    func pageWasFetched(result productListResult: ProductListResult, pageIndex: Int) { }
    
    func showInAppWishlistOnboarding() {
        logInfo("Show in-app wishlist onboarding")
        let wishlistOnboardingViewController = WishlistInAppOnboardingViewController()
        wishlistOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(wishlistOnboardingViewController, presentingViewController: self)
    }
    
    // MARK:- ProductListViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("View switcher did tap retry")
        fetchFirstPage()
    }
    
    func searchProductList(view: SearchProductListView, didTapSearchWithQuery query: String) {
        logInfo("Did tap search with query \(query)")
        updateData(with: EntrySearchInfo(query: query, link: nil))
    }
    
    func searchProductListDidCancelEditing(view: SearchProductListView) {
        logInfo("Did cancel editing")
        castView.queryText = model.query
    }
}

extension SearchProductListViewController: ProductFilterNavigationControllerDelegate {
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

extension SearchProductListViewController: WishlistInAppOnboardingViewControllerDelegate {
    func wishlistOnboardingViewControllerDidTapDismissButton(viewController: WishlistInAppOnboardingViewController) {
        onboardingActionAnimator.dismissViewController(presentingViewController: self)
    }
}
