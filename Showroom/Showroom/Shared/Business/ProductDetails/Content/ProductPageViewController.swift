import Foundation
import UIKit
import RxSwift

protocol ProductPageViewControllerDelegate: class {
    func productPage(page: ProductPageViewController, willChangeProductPageViewState newViewState: ProductPageViewState, animationDuration: Double?)
}

class ProductPageViewController: UIViewController, ProductPageViewDelegate {
    
    var viewContentInset: UIEdgeInsets?
    weak var delegate: ProductPageViewControllerDelegate?
    
    private let model: ProductPageModel
    private var castView: ProductPageView { return view as! ProductPageView }
    private weak var contentNavigationController: ProductDescriptionNavigationController?
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private let actionAnimator = DropUpActionAnimator(height: 207)
    private var firstLayoutSubviewsPassed = false
    
    init(resolver: DiResolver, productId: ObjectId, product: Product?) {
        self.resolver = resolver
        model = resolver.resolve(ProductPageModel.self, arguments: (productId, product))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let descriptionNavigationController = resolver.resolve(ProductDescriptionNavigationController.self, arguments: (model.state, viewContentInset))
        descriptionNavigationController.productDescriptionDelegate = self
        addChildViewController(descriptionNavigationController)
        view = ProductPageView(contentView: descriptionNavigationController.view, descriptionViewInterface: descriptionNavigationController.descriptionView, modelState: model.state, contentInset: viewContentInset)
        descriptionNavigationController.didMoveToParentViewController(self)
        
        self.contentNavigationController = descriptionNavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionAnimator.delegate = self
        
        castView.delegate = self
        
        fetchProductDetails()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        castView.updateWishlistButton(selected: model.isOnWishlist)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        markHandoffUrlActivity(withPath: "/p/\(model.productId)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            let containsInfo = (model.state.product == nil && model.state.productDetails == nil) ?? false
            let initialState: ProductPageViewState = containsInfo ? .ContentHidden : .Default
            castView.changeViewState(initialState, animationDuration: nil, forceUpdate: true)
        }
    }
    
    func dismissContentView() {
        castView.changeViewState(.Default)
        if contentNavigationController?.viewControllers.count > 1 {
            contentNavigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    private func fetchProductDetails() {
        model.fetchProductDetails().subscribeNext { [weak self] fetchResult in
            guard let `self` = self else { return }
            switch fetchResult {
            case .Success(let productDetails):
                logInfo("Successfuly fetched product details: \(productDetails)")
                self.castView.switcherState = .Success
                if self.castView.viewState == .ContentHidden {
                    //hate this approach, but there is no other way to fix blur artefacts
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.castView.changeViewState(.Default, animationDuration: 0.3)
                    })
                }
            case .CacheError(let errorType):
                logInfo("Error while getting product info from cache: \(errorType)")
            case .NetworkError(let errorType):
                logInfo("Error while downloading product info: \(errorType)")
                if self.model.state.productDetails == nil {
                    self.castView.switcherState = self.model.state.product == nil ? .Error : .ModalError
                }
            }
        }.addDisposableTo(disposeBag)
    }
    
    private func showSizePicker(withBuyMode buyMode: Bool = false) {
        guard let sizes = model.pickerSizes else { return }
        guard let productDetails = model.state.productDetails else { return }
        let sizeViewController = resolver.resolve(ProductSizeViewController.self, arguments: (sizes, model.state.currentSize?.id))
        sizeViewController.sizeButtonVisible = productDetails.containSizesMeasurements
        sizeViewController.delegate = self
        sizeViewController.buyMode = buyMode
        actionAnimator.presentViewController(sizeViewController, presentingViewController: self)
    }
    
    private func addToBasket() {
        logAnalyticsEvent(AnalyticsEventId.ProductAddToCartClicked(model.productId))
        model.addToBasket()
        sendNavigationEvent(SimpleNavigationEvent(type: .ProductAddedToBasket))
    }
    
    private func showSizeChart() {
        guard model.state.productDetails != nil else { return }
        
        if castView.viewState == .Default {
            castView.changeViewState(.ContentExpanded)
        }
        
        contentNavigationController?.showSizeChart()
    }
    
    // MARK:- ProductPageViewDelegate
    
    func pageView(pageView: ProductPageView, willChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?) {
        delegate?.productPage(self, willChangeProductPageViewState: newPageViewState, animationDuration: animationDuration)
        if newPageViewState == .Default && contentNavigationController?.viewControllers.count > 1 {
            contentNavigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func pageView(pageView: ProductPageView, didChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?) {
        if newPageViewState == .ImageGallery {
            logAnalyticsEvent(AnalyticsEventId.ProductZoomIn(model.productId))
        } else if newPageViewState == .ContentExpanded {
            logAnalyticsEvent(AnalyticsEventId.ProductShowDetails(model.productId))
        }
    }
    
    func pageViewDidTapShareButton(pageView: ProductPageView) {
        guard let product = model.productSharingInfo else { return }
        
        logAnalyticsEvent(AnalyticsEventId.ProductShare(model.productId))
        
        let shared: [AnyObject] = [product.desc + "\n", product.url]
        
        let shareViewController = UIActivityViewController(activityItems: shared, applicationActivities: nil)
        shareViewController.modalPresentationStyle = .Popover
        presentViewController(shareViewController, animated: true, completion: nil)
        
        if let popoverPresentationController = shareViewController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .Any
        }
    }
    
    func pageViewDidTapWishlistButton(pageView: ProductPageView) {
        let selected = model.switchOnWishlist()
        if selected {
            logAnalyticsEvent(AnalyticsEventId.ProductAddToWishlist(model.productId))
        }
        castView.updateWishlistButton(selected: selected)
    }
    
    func pageViewDidSwitchedImage(pageView: ProductPageView) {
        logAnalyticsEvent(AnalyticsEventId.ProductSwitchPicture(model.productId))
    }
    
    // MARK:- ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        castView.switcherState = model.state.product == nil ? .Loading : .Success
        fetchProductDetails()
    }
}

extension ProductPageViewController: ProductDescriptionNavigationControllerDelegate {
    func productDescription(controller: ProductDescriptionNavigationController, didChangeVisibilityOfFirstChild firstChildVisibility: Bool) {
        castView.contentGestureRecognizerEnabled = firstChildVisibility
    }
    func productDescriptionDidTapSize(controller: ProductDescriptionNavigationController) {
        logAnalyticsEvent(AnalyticsEventId.ProductChangeSizeClicked(model.productId))
        showSizePicker()
    }
    func productDescriptionDidTapColor(controller: ProductDescriptionNavigationController) {
        guard let colors = model.pickerColors else { return }
        
        logAnalyticsEvent(AnalyticsEventId.ProductChangeColorClicked(model.productId))
        
        let colorViewController = resolver.resolve(ProductColorViewController.self, arguments: (colors, model.state.currentColor?.id))
        colorViewController.delegate = self
        actionAnimator.presentViewController(colorViewController, presentingViewController: self)
    }
    func productDescriptionDidTapOtherBrandProducts(controller: ProductDescriptionNavigationController) {
        guard let product = model.state.productDetails else { return }
        
        logAnalyticsEvent(AnalyticsEventId.ProductOtherDesignerProductsClicked(model.productId))
        
        let productBrand = EntryProductBrand(id: product.brand.id, name: product.brand.name, link: nil)
        sendNavigationEvent(ShowBrandProductListEvent(productBrand: productBrand))
    }
    func productDescriptionDidTapAddToBasket(controller: ProductDescriptionNavigationController) {
        guard model.isSizeSet else {
            showSizePicker(withBuyMode: true)
            return
        }
        
        addToBasket()
    }
}

extension ProductPageViewController: ProductSizeViewControllerDelegate {
    func productSize(viewController: ProductSizeViewController, didChangeSize sizeId: ObjectId) {
        actionAnimator.dismissViewController(presentingViewController: self) { [weak self] in
            if viewController.buyMode { self?.addToBasket() }
        }
        model.changeSelectedSize(forSizeId: sizeId)
    }
    
    func productSizeDidTapSizes(viewController: ProductSizeViewController) {
        actionAnimator.dismissViewController(presentingViewController: self) { [weak self] in
            self?.showSizeChart()
        }
    }
    
    func productSize(viewController: ProductSizeViewController, wantDismissWithAnimation animation: Bool) {
        actionAnimator.dismissViewController(presentingViewController: self, animated: animation)
    }
}

extension ProductPageViewController: ProductColorViewControllerDelegate {
    func productColor(viewController viewController: ProductColorViewController, didChangeColor colorId: ObjectId) {
        actionAnimator.dismissViewController(presentingViewController: self)
        model.changeSelectedColor(forColorId: colorId)
        guard let imageIndex = model.state.productDetails?.images.indexOf({ $0.color == colorId }) else { return }
        castView.scrollToImage(atIndex: imageIndex)
    }
    
    func productColor(viewController viewController: ProductColorViewController, wantsDismissWithAnimation animation: Bool) {
        actionAnimator.dismissViewController(presentingViewController: self, animated: animation)
    }
}

extension ProductPageViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        actionAnimator.dismissViewController(presentingViewController: self)
    }
}