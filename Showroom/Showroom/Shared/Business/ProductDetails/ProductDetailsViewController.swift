import Foundation
import UIKit
import RxSwift

class ProductDetailsViewController: UIViewController, ProductDetailsViewDelegate, ProductPageViewControllerDelegate {
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private let model: ProductDetailsModel
    private var castView: ProductDetailsView { return view as! ProductDetailsView }
    private var indexedViewControllers: [Int: UIViewController] = [:]
    private var firstLayoutSubviewsPassed = false
    
    private lazy var onboardingActionAnimator: InAppOnboardingActionAnimator = { [unowned self] in
        return InAppOnboardingActionAnimator(parentViewHeight: self.castView.bounds.height)
    }()
    
    init(resolver: DiResolver, context: ProductDetailsContext) {
        self.resolver = resolver
        model = resolver.resolve(ProductDetailsModel.self, argument: context)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.pageHandler = self
        castView.updatePageCount(withNewProductsAmount: model.productsCount)
        
        model.newProductsAmountObservable.subscribeNext { [weak self] newProductsAmount in
            logInfo("Updating products amount \(newProductsAmount)")
            self?.castView.updatePageCount(withNewProductsAmount: newProductsAmount)
            }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.ProductDetails)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.scrollToPage(atIndex: model.initialProductIndex, animated: false)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !model.userSeenPagingInAppOnboarding {
            showInAppPagingOnboarding()
            model.userSeenPagingInAppOnboarding = true
        }
    }
    
    func updateData(with context: ProductDetailsContext) {
        logInfo("Updating data with context \(context)")
        model.update(with: context)
        removeAllViewControllers()
        castView.reloadPageCount(withNewProductCount: model.productsCount)
        castView.scrollToPage(atIndex: model.initialProductIndex, animated: false)
    }
    
    func showInAppPagingOnboarding() {
        let pagingOnboardingViewController = PagingInAppOnboardingViewController()
        pagingOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(pagingOnboardingViewController, presentingViewController: self)
    }
    
    // MARK: - ProductDetailsViewDelegate
    
    func productDetailsDidTapClose(view: ProductDetailsView) {
        logInfo("Did tap close with current state \(castView.closeButtonState)")
        switch castView.closeButtonState {
        case .Close:
            logAnalyticsEvent(AnalyticsEventId.ProductClose(model.productInfo(forIndex: castView.currentPageIndex).toTuple().0))
            sendNavigationEvent(SimpleNavigationEvent(type: .Close))
        case .Dismiss:
            let productPageViewController = indexedViewControllers[view.currentPageIndex] as! ProductPageViewController
            productPageViewController.dismissContentView()
        }
    }
    
    // MARKL - ProductPageViewControllerDelegate
    
    func productPage(page: ProductPageViewController, willChangeProductPageViewState newViewState: ProductPageViewState, animationDuration: Double?) {
        logInfo("Changing product page state \(newViewState), animationDuration \(animationDuration)")
        castView.changeState(ProductDetailsViewState.fromPageState(newViewState), animationDuration: animationDuration)
        changeTabBarAppearanceIfPossible(newViewState == .ImageGallery ? .Hidden : .Visible, animationDuration: animationDuration)
    }
}

extension ProductDetailsViewController: ProductDetailsPageHandler {
    func page(forIndex index: Int, removePageIndex: Int?) -> UIView {
        logInfo("Creating page for index \(index), removePageIndex \(removePageIndex)")
        let productInfoTuple = model.productInfo(forIndex: index).toTuple()
        let currentViewController = removePageIndex == nil ? nil : indexedViewControllers[removePageIndex!]
        let newViewController = resolver.resolve(ProductPageViewController.self, arguments: productInfoTuple)
        newViewController.viewContentInset = createChildViewContentInset()
        newViewController.delegate = self
        
        currentViewController?.willMoveToParentViewController(nil)
        addChildViewController(newViewController)
        return newViewController.view
    }
    
    func pageAdded(forIndex index: Int, removePageIndex: Int?) {
        logInfo("Page added for index \(index), removePageIndex \(removePageIndex)")
        let currentViewController = removePageIndex == nil ? nil : indexedViewControllers[removePageIndex!]
        let newViewController = childViewControllers.last!
        
        currentViewController?.removeFromParentViewController()
        newViewController.didMoveToParentViewController(self)
        
        if removePageIndex != nil {
            indexedViewControllers[removePageIndex!] = nil
        }
        indexedViewControllers[index] = newViewController
        model.didMoveToPage(atIndex: index)
        logInfo("Indexed view controllers \(indexedViewControllers)")
    }
    
    private func removeAllViewControllers() {
        logInfo("Remove all view controllers \(indexedViewControllers)")
        indexedViewControllers.forEach { (index, viewController) in
            viewController.forceCloseModal()
            viewController.willMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        indexedViewControllers.removeAll()
    }
    
    //perfectly parent should set content inset, but it would be too much work and too much complications
    private func createChildViewContentInset() -> UIEdgeInsets {
        let bottomInset = bottomLayoutGuide.length == 0 ? Dimensions.tabViewHeight : bottomLayoutGuide.length
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
}

extension ProductDetailsViewController: PagingInAppOnboardingViewControllerDelegate {
    func pagingOnboardingViewControllerDidTapDismiss(viewController: PagingInAppOnboardingViewController) {
        onboardingActionAnimator.dismissViewController(presentingViewController: self)
    }
}


extension ProductDetailsViewState {
    static func fromPageState(pageState: ProductPageViewState) -> ProductDetailsViewState {
        switch pageState {
        case .Default, .ContentHidden:
            return .Close
        case .ContentExpanded:
            return .Dismiss
        case .ImageGallery:
            return .FullScreen
        }
    }
}