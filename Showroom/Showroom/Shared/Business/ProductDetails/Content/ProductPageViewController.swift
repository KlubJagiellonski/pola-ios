import Foundation
import UIKit
import RxSwift

protocol ProductPageViewControllerDelegate: class {
    func productPage(page: ProductPageViewController, didChangeProductPageViewState viewState: ProductPageViewState)
}

<<<<<<< b26866bb79ba043ebcca2c363f2fb73f9c99c03b
class ProductPageViewController: UIViewController, ProductPageViewDelegate, ProductDescriptionViewControllerDelegate, DropUpActionDelegate {
=======
class ProductPageViewController: UIViewController, ProductPageViewDelegate, ProductDescriptionViewControllerDelegate, UIPopoverPresentationControllerDelegate {
>>>>>>> added sharing product (brand, name, url)
    let model: ProductPageModel
    var castView: ProductPageView { return view as! ProductPageView }
    var viewContentInset: UIEdgeInsets?
    weak var delegate: ProductPageViewControllerDelegate?
    
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private let actionAnimator = DropUpActionAnimator(height: 216)
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        model = resolver.resolve(ProductPageModel.self)
        
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
        addChildViewController(navigationController)
        view = ProductPageView(contentView: navigationController.view, descriptionViewInterface: descriptionViewController.view as! ProductDescriptionViewInterface, modelState: model.state)
        navigationController.didMoveToParentViewController(self)
        actionAnimator.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.contentInset = viewContentInset
        castView.delegate = self
        
        model.fetchProductDetails(1234).subscribeNext { fetchResult in
            switch fetchResult {
            case .Success(let productDetails):
                logInfo("Successfuly fetched product details: \(productDetails)")
            case .NetworkError(let errorType):
                logInfo("Error while downloading product info: \(errorType)")
            }
        }.addDisposableTo(disposeBag)
    }
    
    func dismissContentView() {
        castView.changeViewState(.Default, animated: true)
    }
    
    // MARK:- ProductPageViewDelegate
    
    func pageView(pageView: ProductPageView, didChangePageViewState pageViewState: ProductPageViewState) {
        delegate?.productPage(self, didChangeProductPageViewState: pageViewState)
    }
    
    func pageViewDidTapShareButton(pageView: ProductPageView) {
        
        let sharedProduct: (desc: String, url: NSURL)? = { _ in
            let baseUrl = "https://www.showroom.pl/p/"
            
            if let product = model.state.product {
                return (product.brand.name + " " + product.name, NSURL(string: baseUrl + String(product.id))!)
            } else if let productDetails = model.state.productDetails {
                return (productDetails.brand.name + " " + productDetails.name, NSURL(string: baseUrl + String(productDetails.id))!)
            } else {
                return nil
            }
        }()
        
        if let product = sharedProduct {
            let shared: [AnyObject] = [product.desc + "\n", product.url]
            
            let shareViewController = UIActivityViewController(activityItems: shared, applicationActivities: nil)
            shareViewController.modalPresentationStyle = .Popover
            presentViewController(shareViewController, animated: true, completion: nil)
            
            if let popoverPresentationController = shareViewController.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .Any
                popoverPresentationController.delegate = self
            }
        } else {
            print("failed to get product details")
        }
    }
    
    // MARK :- ProductDescriptionViewControllerDelegate
    
    func descriptionViewDidTapSize(view: ProductDescriptionView) {
        guard let sizes = model.pickerSizes else { return }
        
        let sizeViewController = resolver.resolve(ProductSizeViewController.self, arguments: (sizes, model.state.currentSize?.id))
        sizeViewController.delegate = self
        actionAnimator.presentViewController(sizeViewController, presentingVC: self)
    }
    
    func descriptionViewDidTapColor(view: ProductDescriptionView) {
        guard let colors = model.pickerColors else { return }
        
        let colorViewController = resolver.resolve(ProductColorViewController.self, arguments: (colors, model.state.currentColor?.id))
        colorViewController.delegate = self
        actionAnimator.presentViewController(colorViewController, presentingVC: self)
    }
    
    func descriptionViewDidTapSizeChart(view: ProductDescriptionView) {
        
    }
    
    func descriptionViewDidTapOtherBrandProducts(view: ProductDescriptionView) {
        
    }
    
    func descriptionViewDidTapAddToBasket(view: ProductDescriptionView) {
        
    }
    
    func dropUpActionDidTapDimView(animator: DropUpActionAnimator) {
        actionAnimator.dismissViewController(presentingViewController: self)
    }
    
}

extension ProductPageViewController: ProductSizeViewControllerDelegate {
    func productSize(viewController: ProductSizeViewController, didChangeSize sizeId: ObjectId) {
        actionAnimator.dismissViewController(presentingViewController: self)
        model.changeSelectedSize(forSizeId: sizeId)
    }
    
    func productSizeDidTapSizes(viewController: ProductSizeViewController) {
        //todo show size chart
    }
}

extension ProductPageViewController: ProductColorViewControllerDelegate {
    func productColor(viewController viewController: ProductColorViewController, didChangeColor colorId: ObjectId) {
        actionAnimator.dismissViewController(presentingViewController: self)
        model.changeSelectedColor(forColorId: colorId)
    }
}