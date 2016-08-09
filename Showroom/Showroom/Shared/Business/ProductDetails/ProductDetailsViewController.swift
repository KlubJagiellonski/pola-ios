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
    
    init(resolver: DiResolver, context: ProductDetailsContext) {
        self.resolver = resolver
        model = resolver.resolve(ProductDetailsModel.self, argument: context)
        
        super.init(nibName: nil, bundle: nil)
        
        model.newProductsAmountObservable.subscribeNext { [weak self] newProductsAmount in
            self?.castView.updatePageCount(withNewProductsAmount: newProductsAmount)
        }.addDisposableTo(disposeBag)
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
    
    func updateData(with context: ProductDetailsContext) {
        model.update(with: context)
        removeAllViewControllers()
        castView.reloadPageCount(withNewProductCount: model.productsCount)
        castView.scrollToPage(atIndex: model.initialProductIndex, animated: false)
    }
    
    // MARK: - ProductDetailsViewDelegate
    
    func productDetailsDidTapClose(view: ProductDetailsView) {
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
        castView.changeState(ProductDetailsViewState.fromPageState(newViewState), animationDuration: animationDuration)
        changeTabBarAppearanceIfPossible(newViewState == .ImageGallery ? .Hidden : .Visible, animationDuration: animationDuration)
    }
}

extension ProductDetailsViewController: ProductDetailsPageHandler {
    func page(forIndex index: Int, removePageIndex: Int?) -> UIView {
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
        let currentViewController = removePageIndex == nil ? nil : indexedViewControllers[removePageIndex!]
        let newViewController = childViewControllers.last!
        
        currentViewController?.removeFromParentViewController()
        newViewController.didMoveToParentViewController(self)
        
        if removePageIndex != nil {
            indexedViewControllers[removePageIndex!] = nil
        }
        indexedViewControllers[index] = newViewController
        model.didMoveToPage(atIndex: index)
    }
    
    private func removeAllViewControllers() {
        indexedViewControllers.forEach { (index, viewController) in
            viewController.forceCloseModal()
            viewController.willMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        indexedViewControllers.removeAll()
    }
    
    //todo perfectly parent should set content inset, but it would be too much work and too much complications
    private func createChildViewContentInset() -> UIEdgeInsets {
        let bottomInset = bottomLayoutGuide.length == 0 ? Dimensions.tabViewHeight : bottomLayoutGuide.length
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
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