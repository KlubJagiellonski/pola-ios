import Foundation
import UIKit

protocol PresenterContentChildProtocol {
    func presenterWillApear()
}

class PresenterViewController: UIViewController, PresenterViewDelegate {
    var castView: PresenterView { return view as! PresenterView }
    private(set) var contentViewController: UIViewController?
    private(set) var currentModalViewController: UIViewController?
    
    private var forceContentForControllingBarHiddenStates = false
    private var contentHiddenWhenModalVisible: Bool?
    
    override func loadView() {
        self.view = PresenterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let contentViewController = self.contentViewController as? PresenterContentChildProtocol {
            contentViewController.presenterWillApear()
        }
    }
    
    final func showContent(viewController: UIViewController, animation: TransitionAnimation?, completion: ((Bool) -> ())?) {
        contentViewController?.willMoveToParentViewController(nil)
        addChildViewController(viewController)
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            guard let `self` = self else { return }
            self.contentViewController?.removeFromParentViewController()
            viewController.didMoveToParentViewController(self)
            self.contentViewController = viewController
        }
        castView.showContent(viewController.view, customAnimation: animation?.show, completion: innerCompletion)
    }
    
    final func showModal(viewController: UIViewController, hideContentView: Bool, animation: TransitionAnimation?, completion: ((Bool) -> ())?) {
        guard currentModalViewController == nil else {
            completion?(false)
            return
        }
        
        contentHiddenWhenModalVisible = hideContentView
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            viewController.didMoveToParentViewController(self)
            if hideContentView {
                self?.contentViewController?.willMoveToParentViewController(nil)
                self?.castView.contentHidden = true
                self?.contentViewController?.removeFromParentViewController()
            }
            completion?(true)
        }
        
        animation?.additionalAnimationBlock = { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
            self?.setNeedsTabBarAppearanceUpdate()
        }
        
        addChildViewController(viewController)
        self.currentModalViewController = viewController
        castView.showModal(viewController.view, customAnimation: animation?.show, completion: innerCompletion)
    }
    
    final func hideModal(animation animation: TransitionAnimation?, completion: ((Bool) -> ())?) {
        guard let currentModalViewController = currentModalViewController else {
            completion?(false)
            return
        }
        
        contentHiddenWhenModalVisible = nil
        
        if let contentViewController = self.contentViewController where castView.contentHidden {
            addChildViewController(contentViewController)
            castView.contentHidden = false
            contentViewController.didMoveToParentViewController(self)
        }
        
        let innerCompletion: (Bool) -> () = { [weak self] _ in
            currentModalViewController.removeFromParentViewController()
            self?.currentModalViewController = nil
            completion?(true)
        }
        
        animation?.additionalAnimationBlock = { [weak self] in
            guard let `self` = self else { return }
            self.forceContentForControllingBarHiddenStates = true
            self.setNeedsStatusBarAppearanceUpdate()
            self.setNeedsTabBarAppearanceUpdate()
            self.forceContentForControllingBarHiddenStates = false
        }
        
        currentModalViewController.willMoveToParentViewController(nil)
        castView.hideModal(animation?.hide, completion: innerCompletion)
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        if forceContentForControllingBarHiddenStates {
            return contentViewController
        }
        //we want to get status bar info only from view controller that wants to handle it
        if let statusBarHandler = currentModalViewController as? StatusBarAppearanceHandling
            where statusBarHandler.wantsHandleStatusBarAppearance {
            return currentModalViewController
        }
        return contentViewController
    }
    
    // MARK:- PresenterViewDelegate
    
    func presenterWantsToHideModalView(view: PresenterView) {
        logInfo("Wants hide modal view")
        sendNavigationEvent(SimpleNavigationEvent(type: .Close))
    }
    
    func presenterWillBeginHideModalPanning(view: PresenterView) {
        logInfo("Will begin hide modal panning")
        
        guard let contentViewController = contentViewController else { return }
        guard let contentHiddenWhenModalVisible = contentHiddenWhenModalVisible where contentHiddenWhenModalVisible else { return }
        
        addChildViewController(contentViewController)
        castView.contentHidden = false
        contentViewController.didMoveToParentViewController(self)
    }
    
    func presenterDidEndHideModalPanning(view: PresenterView) {
        logInfo("Did end hide modal panning")
        
        guard let contentViewController = contentViewController else { return }
        guard let contentHiddenWhenModalVisible = contentHiddenWhenModalVisible where contentHiddenWhenModalVisible else { return }
        
        contentViewController.willMoveToParentViewController(nil)
        castView.contentHidden = true
        contentViewController.removeFromParentViewController()
    }
    
}

extension PresenterViewController: TabBarHandler, TabBarStateDataSource {
    func dataSourceForTabBarHidden() -> TabBarStateDataSource? {
        guard let dataSource = currentModalViewController as? TabBarStateDataSource
        where !forceContentForControllingBarHiddenStates else {
            return self
        }
        return dataSource
    }
    
    var prefersTabBarHidden: Bool {
        return false
    }
}