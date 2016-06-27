import Foundation
import UIKit
import RxSwift

protocol ProductPageViewControllerDelegate: class {
    func productPage(page: ProductPageViewController, willChangeProductPageViewState newViewState: ProductPageViewState, animationDuration: Double?)
}

class ProductPageViewController: UIViewController, ProductPageViewDelegate, ProductDescriptionViewControllerDelegate {
    
    var viewContentInset: UIEdgeInsets?
    weak var delegate: ProductPageViewControllerDelegate?
    
    private let model: ProductPageModel
    private var castView: ProductPageView { return view as! ProductPageView }
    private weak var contentNavigationController: UINavigationController?
    private weak var descriptionViewController: ProductDescriptionViewController?
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private let actionAnimator = DropUpActionAnimator(height: 216)
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
        let descriptionViewController = resolver.resolve(ProductDescriptionViewController.self, argument: model.state)
        descriptionViewController.viewContentInset = viewContentInset
        descriptionViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: descriptionViewController)
        navigationController.navigationBarHidden = true
        navigationController.delegate = self
        addChildViewController(navigationController)
        view = ProductPageView(contentView: navigationController.view, descriptionViewInterface: descriptionViewController.view as! ProductDescriptionViewInterface, modelState: model.state)
        navigationController.didMoveToParentViewController(self)
        
        self.contentNavigationController = navigationController
        self.descriptionViewController = descriptionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionAnimator.delegate = self
        
        castView.contentInset = viewContentInset
        castView.delegate = self
        
        fetchProductDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.changeViewState(.Default, animationDuration: nil, forceUpdate: true)
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
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .Success(let productDetails):
                logInfo("Successfuly fetched product details: \(productDetails)")
                strongSelf.castView.switcherState = .Success
            case .CacheError(let errorType):
                logInfo("Error while getting product info from cache: \(errorType)")
            case .NetworkError(let errorType):
                logInfo("Error while downloading product info: \(errorType)")
                if strongSelf.model.state.productDetails == nil {
                    strongSelf.castView.switcherState = strongSelf.model.state.product == nil ? .Error : .ModalError
                }
            }
            }.addDisposableTo(disposeBag)
    }
    
    private func showSizePicker(withBuyMode buyMode: Bool = false) {
        guard let sizes = model.pickerSizes else { return }
        let sizeViewController = resolver.resolve(ProductSizeViewController.self, arguments: (sizes, model.state.currentSize?.id))
        sizeViewController.delegate = self
        sizeViewController.buyMode = buyMode
        actionAnimator.presentViewController(sizeViewController, presentingViewController: self)
    }
    
    private func addToBasket() {
        model.addToBasket()
    }
    
    private func showSizeChart() {
        guard let productDetails = model.state.productDetails else { return }
        
        if castView.viewState == .Default {
            castView.changeViewState(.ContentVisible)
        }
        
        let viewController = resolver.resolve(SizeChartViewController.self, argument: productDetails.sizes)
        viewController.delegate = self
        viewController.viewContentInset = viewContentInset
        contentNavigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK:- ProductPageViewDelegate
    
    func pageView(pageView: ProductPageView, willChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?) {
        delegate?.productPage(self, willChangeProductPageViewState: newPageViewState, animationDuration: animationDuration)
        if newPageViewState == .Default && contentNavigationController?.viewControllers.count > 1 {
            contentNavigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func pageView(pageView: ProductPageView, didChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?) {
        
    }
    
    func pageViewDidTapShareButton(pageView: ProductPageView) {
        guard let product = model.productSharingInfo else { return }
        
        let shared: [AnyObject] = [product.desc + "\n", product.url]
        
        let shareViewController = UIActivityViewController(activityItems: shared, applicationActivities: nil)
        shareViewController.modalPresentationStyle = .Popover
        presentViewController(shareViewController, animated: true, completion: nil)
        
        if let popoverPresentationController = shareViewController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .Any
        }
    }
    
    // MARK:- ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        castView.switcherState = model.state.product == nil ? .Loading : .Success
        fetchProductDetails()
    }
    
    // MARK :- ProductDescriptionViewControllerDelegate
    
    func descriptionViewDidTapSize(view: ProductDescriptionView) {
        showSizePicker()
    }
    
    func descriptionViewDidTapColor(view: ProductDescriptionView) {
        guard let colors = model.pickerColors else { return }
        
        let colorViewController = resolver.resolve(ProductColorViewController.self, arguments: (colors, model.state.currentColor?.id))
        colorViewController.delegate = self
        actionAnimator.presentViewController(colorViewController, presentingViewController: self)
    }
    
    func descriptionViewDidTapSizeChart(view: ProductDescriptionView) {
        showSizeChart()
    }
    
    func descriptionViewDidTapOtherBrandProducts(view: ProductDescriptionView) {}
    
    func descriptionViewDidTapAddToBasket(view: ProductDescriptionView) {
        guard !model.isSizeSet else {
            addToBasket()
            return
        }
        
        showSizePicker(withBuyMode: true)
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
}

extension ProductPageViewController: ProductColorViewControllerDelegate {
    func productColor(viewController viewController: ProductColorViewController, didChangeColor colorId: ObjectId) {
        actionAnimator.dismissViewController(presentingViewController: self)
        model.changeSelectedColor(forColorId: colorId)
    }
}

extension ProductPageViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        actionAnimator.dismissViewController(presentingViewController: self)
    }
}

extension ProductPageViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if !(viewController is ProductDescriptionViewController) {
            castView.contentGestureRecognizerEnabled = false
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if viewController is ProductDescriptionViewController {
            castView.contentGestureRecognizerEnabled = true
        }
    }
}

extension ProductPageViewController: SizeChartViewControllerDelegate {
    func sizeChartDidTapBack(viewController: SizeChartViewController) {
        contentNavigationController?.popViewControllerAnimated(true)
    }
}