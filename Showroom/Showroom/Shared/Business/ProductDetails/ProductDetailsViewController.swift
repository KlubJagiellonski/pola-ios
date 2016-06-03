import Foundation
import UIKit

class ProductDetailsViewController: UIViewController, ProductDetailsViewDelegate {
    
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
        sendNavigationEvent(SimpleNavigationEvent(type: .Close))
    }
}

extension ProductDetailsViewController: ProductDetailsPageHandler {
    func page(forIndex index: Int, removePageIndex: Int) -> UIView {
        let currentViewController = indexedViewControllers[removePageIndex]
        let newViewController = resolver.resolve(ProductPageViewController.self, argument: index % 2 == 0 ? UIColor.blueColor() : UIColor.blackColor())
        
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