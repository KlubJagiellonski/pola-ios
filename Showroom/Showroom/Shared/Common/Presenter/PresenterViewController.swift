import Foundation
import UIKit

class PresenterViewController: UIViewController {
    var castView: PresenterView { return view as! PresenterView }
    
    var contentViewController: UIViewController? {
        didSet {
            guard let newViewController = contentViewController else {
                fatalError("Cannot set nil contentViewController")
            }
            
            oldValue?.willMoveToParentViewController(nil)
            addChildViewController(newViewController)
            
            castView.contentView = newViewController.view
            
            oldValue?.removeFromParentViewController()
            newViewController.didMoveToParentViewController(self)
        }
    }
    
    var currentModalViewController: UIViewController? {
        didSet {
            oldValue?.willMoveToParentViewController(nil)
            if let newViewController = currentModalViewController {
                addChildViewController(newViewController)
            }
            castView.modalView = currentModalViewController?.view
            oldValue?.removeFromParentViewController()
            currentModalViewController?.didMoveToParentViewController(self)
        }
    }
    
    override func loadView() {
        self.view = PresenterView()
    }
}
