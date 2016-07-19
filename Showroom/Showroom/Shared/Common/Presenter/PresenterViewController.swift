import Foundation
import UIKit

protocol PresenterModalAnimation {
    func showModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?)
    func hideModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?)
}

protocol PresenterContentChildProtocol {
    func presenterWillApear()
}

class PresenterViewController: UIViewController {
    var castView: PresenterView { return view as! PresenterView }
    private(set) var hiddenContentViewController: UIViewController?
    
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
    
    private(set) var currentModalViewController: UIViewController?
    
    override func loadView() {
        self.view = PresenterView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let contentViewController = self.contentViewController as? PresenterContentChildProtocol {
            contentViewController.presenterWillApear()
        }
    }
    
    func showModal(viewController: UIViewController, hideContentView: Bool, animation: PresenterModalAnimation?, completion: ((Bool) -> ())?) {
        guard currentModalViewController == nil else {
            completion?(false)
            return
        }
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            viewController.didMoveToParentViewController(self)
            if hideContentView {
                self?.hiddenContentViewController = self?.contentViewController
                self?.contentViewController = nil
            }
            completion?(true)
        }
        
        addChildViewController(viewController)
        self.currentModalViewController = viewController
        castView.showModal(viewController.view, customAnimation: animation?.showModal, completion: innerCompletion)
    }
    
    func hideModal(animation animation: PresenterModalAnimation?, completion: ((Bool) -> ())?) {
        guard let currentModalViewController = currentModalViewController else {
            completion?(false)
            return
        }
        
        if let cachedContentViewController = hiddenContentViewController {
            contentViewController = cachedContentViewController
            self.hiddenContentViewController = nil
        }
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            currentModalViewController.removeFromParentViewController()
            self?.currentModalViewController = nil
            completion?(true)
        }
        
        currentModalViewController.willMoveToParentViewController(nil)
        castView.hideModal(animation?.hideModal, completion: innerCompletion)
    }
}