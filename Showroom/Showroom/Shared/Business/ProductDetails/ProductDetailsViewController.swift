import Foundation
import UIKit
import RxSwift

class ProductDetailsViewController: UIViewController, ProductDetailsViewDelegate, ProductPageViewControllerDelegate {
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private let model: ProductDetailsModel
    private var castView: ProductDetailsView { return view as! ProductDetailsView }
    private var indexedViewControllers: [Int: UIViewController] = [:]
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.scrollToPage(atIndex: model.initialProductIndex, animated: false)
    }
    
    // MARK: - ProductDetailsViewDelegate
    
    func productDetailsDidTapClose(view: ProductDetailsView) {
        switch castView.closeButtonState {
        case .Close:
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
        newViewController.viewContentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
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
}

extension ProductDetailsViewState {
    static func fromPageState(pageState: ProductPageViewState) -> ProductDetailsViewState{
        switch pageState {
        case .Default:
            return .Close
        case .ContentVisible:
            return .Dismiss
        case .ImageGallery:
            return .FullScreen
        }
    }
}