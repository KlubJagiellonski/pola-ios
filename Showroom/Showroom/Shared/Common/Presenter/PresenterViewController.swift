import Foundation
import UIKit

class PresenterViewController: UIViewController {
    var castView: PresenterView { return view as! PresenterView }
    private var cachedContentViewController: UIViewController?
    
    var contentViewController: UIViewController? {
        didSet {
            oldValue?.willMoveToParentViewController(nil)
            if let newViewController = contentViewController {
                addChildViewController(newViewController)
            }
            castView.contentView = contentViewController?.view
            oldValue?.removeFromParentViewController()
            contentViewController?.didMoveToParentViewController(self)
        }
    }
    
    var currentModalViewController: UIViewController? {
        didSet {
            if let cachedContentViewController = cachedContentViewController {
                contentViewController = cachedContentViewController
                self.cachedContentViewController = nil
            }
            
            oldValue?.willMoveToParentViewController(nil)
            if let newViewController = currentModalViewController {
                addChildViewController(newViewController)
            }
            castView.modalView = currentModalViewController?.view
            oldValue?.removeFromParentViewController()
            currentModalViewController?.didMoveToParentViewController(self)
            
            if currentModalViewController != nil {
                cachedContentViewController = contentViewController
                contentViewController = nil
            }
        }
    }
    
    override func loadView() {
        self.view = PresenterView()
    }
}
