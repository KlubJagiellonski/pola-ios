import Foundation
import UIKit

protocol PresenterModalAnimation {
    func showModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?)
    func hideModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?)
}

struct DimModalAnimation: PresenterModalAnimation {
    let animationDuration: NSTimeInterval
    
    func showModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        modalView.alpha = 0.0
        containerView.addSubview(modalView)
        modalView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animateWithDuration(animationDuration, animations: {
            modalView.alpha = 1.0
        }, completion: completion)
    }
    
    func hideModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        modalView.alpha = 1.0
        UIView.animateWithDuration(animationDuration, animations: {
            modalView.alpha = 0.0
        }) { success in
            modalView.removeFromSuperview()
            completion?(success)
        }
    }
}

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
    
    private(set) var currentModalViewController: UIViewController?
    
    override func loadView() {
        self.view = PresenterView()
    }
    
    func showModal(viewController: UIViewController, hideContentView: Bool, animation: PresenterModalAnimation?, completion: ((Bool) -> ())?) {
        guard currentModalViewController == nil else {
            completion?(false)
            return
        }
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            viewController.didMoveToParentViewController(self)
            if hideContentView {
                self?.cachedContentViewController = self?.contentViewController
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
        
        if let cachedContentViewController = cachedContentViewController {
            contentViewController = cachedContentViewController
            self.cachedContentViewController = nil
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
