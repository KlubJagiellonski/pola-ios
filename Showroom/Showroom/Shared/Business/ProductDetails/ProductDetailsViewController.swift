import Foundation
import UIKit

class ProductDetailsViewController: UIViewController, ProductDetailsViewDelegate, ProductPageViewControllerDelegate {
    
    let resolver: DiResolver
    
    let model: ProductDetailsModel
    var castView: ProductDetailsView { return view as! ProductDetailsView }
    
    var indexedViewControllers: [Int: UIViewController] = [:]
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(ProductDetailsModel.self)
        
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
        castView.updatePageCount(model.pageCount)
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
        let currentViewController = indexedViewControllers[removePageIndex]
        let newViewController = resolver.resolve(ProductPageViewController.self)
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
    }
}