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
        
        model.productInfosObservable.subscribeNext { [weak self] products in
            self?.castView.updatePageCount(products.count)
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
        castView.updatePageCount(model.productInfos.count)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func productPage(page: ProductPageViewController, didChangeProductPageViewState viewState: ProductPageViewState) {
        switch viewState {
        case .Default:
            castView.closeButtonState = .Close
        case .ContentVisible:
            castView.closeButtonState = .Dismiss
        case .ImageGallery: break // todo image gallery
        }
    }
}

extension ProductDetailsViewController: ProductDetailsPageHandler {
    func page(forIndex index: Int, removePageIndex: Int) -> UIView {
        let productInfoTuple = model.productInfos[index].toTuple()
        let currentViewController = indexedViewControllers[removePageIndex]
        let newViewController = resolver.resolve(ProductPageViewController.self, arguments: productInfoTuple)
        newViewController.viewContentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        newViewController.delegate = self
        
        currentViewController?.willMoveToParentViewController(nil)
        addChildViewController(newViewController)
        return newViewController.view
    }
    
    func pageAdded(forIndex index: Int, removePageIndex: Int) {
        let currentViewController = indexedViewControllers[removePageIndex]
        let newViewController = childViewControllers.last!
        
        currentViewController?.removeFromParentViewController()
        newViewController.didMoveToParentViewController(self)
        
        indexedViewControllers[removePageIndex] = nil
        indexedViewControllers[index] = newViewController
        model.didMoveToPage(atIndex: index)
    }
}