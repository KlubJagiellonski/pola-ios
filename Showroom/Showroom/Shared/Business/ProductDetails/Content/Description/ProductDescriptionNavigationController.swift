import Foundation

protocol ProductDescriptionNavigationControllerDelegate: class {
    func productDescription(controller: ProductDescriptionNavigationController, didChangeVisibilityOfFirstChild firstChildVisibility: Bool)
    func productDescriptionDidTapSize(controller: ProductDescriptionNavigationController)
    func productDescriptionDidTapColor(controller: ProductDescriptionNavigationController)
    func productDescriptionDidTapOtherBrandProducts(controller: ProductDescriptionNavigationController)
    func productDescriptionDidTapAddToBasket(controller: ProductDescriptionNavigationController)
}

final class ProductDescriptionNavigationController: UINavigationController {
    weak var productDescriptionDelegate: ProductDescriptionNavigationControllerDelegate?
    private let state: ProductPageModelState
    private let resolver: DiResolver
    private let viewContentInset: UIEdgeInsets?
    var descriptionView: ProductDescriptionViewInterface {
        return viewControllers[0].view as! ProductDescriptionViewInterface
    }
    
    init(resolver: DiResolver, state: ProductPageModelState, viewContentInset: UIEdgeInsets?) {
        self.state = state
        self.resolver = resolver
        self.viewContentInset = viewContentInset
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyTranslucentPopupStyle()
        setNavigationBarHidden(true, animated: false)
        delegate = self
        
        let descriptionViewController = resolver.resolve(ProductDescriptionViewController.self, argument: state)
        descriptionViewController.viewContentInset = viewContentInset
        descriptionViewController.delegate = self
        descriptionViewController.resetBackTitle()
        viewControllers = [descriptionViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSizeChart() {
        logInfo("Showing size chart")
        guard let productDetails = state.productDetails else { return }
        
        logAnalyticsEvent(AnalyticsEventId.ProductSizeTableShown(state.product?.id ?? 0))
        
        let viewController = resolver.resolve(SizeChartViewController.self, argument: productDetails.sizes)
        viewController.viewContentInset = viewContentInset
        pushViewController(viewController, animated: true)
    }
}

extension ProductDescriptionNavigationController: ProductDescriptionViewControllerDelegate {
    func descriptionViewDidTapSize(view: ProductDescriptionView) {
        logInfo("Did tap size")
        productDescriptionDelegate?.productDescriptionDidTapSize(self)
    }
    func descriptionViewDidTapColor(view: ProductDescriptionView) {
        logInfo("Did tap color")
        productDescriptionDelegate?.productDescriptionDidTapColor(self)
    }
    func descriptionViewDidTapSizeChart(view: ProductDescriptionView) {
        logInfo("Did tap size chart")
        showSizeChart()
    }
    func descriptionViewDidTapOtherBrandProducts(view: ProductDescriptionView) {
        logInfo("Did tap other brand products")
        productDescriptionDelegate?.productDescriptionDidTapOtherBrandProducts(self)
    }
    func descriptionViewDidTapAddToBasket(view: ProductDescriptionView) {
        logInfo("Did tap add to basket")
        productDescriptionDelegate?.productDescriptionDidTapAddToBasket(self)
    }
}

extension ProductDescriptionNavigationController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        logInfo("willShowViewController \(viewController)")
        if !(viewController is ProductDescriptionViewController) {
            productDescriptionDelegate?.productDescription(self, didChangeVisibilityOfFirstChild: false)
            setNavigationBarHidden(false, animated: animated)
        } else {
            setNavigationBarHidden(true, animated: animated)
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        logInfo("didShowViewController \(viewController)")
        if viewController is ProductDescriptionViewController {
            productDescriptionDelegate?.productDescription(self, didChangeVisibilityOfFirstChild: true)
        }
    }
}