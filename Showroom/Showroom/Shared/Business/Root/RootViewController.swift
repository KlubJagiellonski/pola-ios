import Foundation
import UIKit
import Swinject

class RootViewController: PresenterViewController, NavigationHandler {
    private let model: RootModel
    private let resolver: DiResolver
    private var urlToHandle: NSURL?
    private lazy var formSheetAnimator: FormSheetAnimator = { [unowned self] in
        let animator = FormSheetAnimator()
        animator.delegate = self
        return animator
    }()
    
    init?(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(RootModel.self)
        super.init(nibName: nil, bundle: nil)
        
        showModal(resolver.resolve(SplashViewController.self), hideContentView: false, animation: nil, completion: nil)
        
        switch model.startChildType {
        case .Start:
            showContent(resolver.resolve(StartViewController), animation: nil, completion: nil)
        case .Main:
            showContent(resolver.resolve(MainTabViewController), animation: nil, completion: nil)
        case .Onboarding:
            showContent(resolver.resolve(InitialOnboardingViewController), animation: nil, completion: nil)
        default:
            let error = "Cannot create view controller for type \(model.startChildType)"
            logError(error)
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.apiService.delegate = self
    }
    
    func handleQuickActionShortcut(shortcut: ShortcutIdentifier) {
        if let mainTabViewController = self.contentViewController as? MainTabViewController {
            mainTabViewController.handleQuickActionShortcut(shortcut)
        } else {
            let mainTabViewController = resolver.resolve(MainTabViewController)
            mainTabViewController.handleQuickActionShortcut(shortcut)
            showContent(mainTabViewController, animation: nil, completion: nil)
        }
    }
    
    private func showRateAppViewIfNeeded() -> Bool {
        guard model.rateAppManager.shouldShowRateAppView else {
            return false
        }
        
        let viewController = self.resolver.resolve(RateAppViewController.self, argument: RateAppViewType.AfterTime)
        viewController.preferredContentSize = Dimensions.rateAppPreferredSize
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        model.rateAppManager.didShowRateAppView()
        return true
    }
    
    private func showNotificationAccessView() {
        let viewController = self.resolver.resolve(NotificationsAccessViewController.self, argument: NotificationsAccessViewType.AfterTime)
        viewController.preferredContentSize = Dimensions.notificationAccessPreferredSize
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        model.notificationManager.didShowNotificationsAccessView()
    }
    
    // MARK: - NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        guard let simpleEvent = event as? SimpleNavigationEvent else { return false }
        
        switch simpleEvent.type {
        case .ShowDashboard:
            model.shouldSkipStartScreen = true
            let mainTabViewController = resolver.resolve(MainTabViewController)
            showContent(mainTabViewController, animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            if let urlToHandle = urlToHandle {
                mainTabViewController.handleOpen(withURL: urlToHandle)
                self.urlToHandle = nil
            }
            return true
        case .SplashEnd:
            hideModal(animation: nil) { [weak self] _ in
                guard let `self` = self else { return }
                if !self.showRateAppViewIfNeeded() && self.model.notificationManager.shouldAskForRemoteNotifications {
                    self.showNotificationAccessView()
                }
            }
            return true
        case .OnboardingEnd:
            showContent(resolver.resolve(StartViewController), animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            return true
        case .ShowOnboaridng:
            showContent(resolver.resolve(InitialOnboardingViewController), animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            return true
        case .AskForNotificationsFromWishlist:
            // Only happens when the user adds something to the wishlist.
            if model.notificationManager.shouldShowNotificationsAccessViewFromWishlist {
                showNotificationAccessView()
            }
            return true
        default: return false
        }
    }
}

extension RootViewController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        if let mainTabViewController = self.contentViewController as? MainTabViewController {
            return mainTabViewController.handleOpen(withURL: url)
        } else if model.shouldSkipStartScreen {
            let mainTabViewController = resolver.resolve(MainTabViewController.self)
            showContent(mainTabViewController, animation: nil, completion: nil)
            return mainTabViewController.handleOpen(withURL: url)
        } else {
            //wait with handling till app finish onboarding and start
            urlToHandle = url
            return true
        }
    }
}

extension RootViewController: ApiServiceDelegate {
    func apiServiceDidReceiveAppNotSupportedError(api: ApiService) {
        guard presentedViewController == nil else { return }
        
        let acceptAction: (UIAlertAction -> Void) = { _ in
            if let appStoreUrl = NSURL(string: Constants.appStoreUrl) {
                UIApplication.sharedApplication().openURL(appStoreUrl)
            }
        }
        
        let alert = UIAlertController(title: tr(.AppVersionNotSupportedTitle), message: tr(.AppVersionNotSupportedDescription), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: tr(.AppVersionNotSupportedAccept), style: .Default, handler: acceptAction))
        alert.addAction(UIAlertAction(title: tr(.AppVersionNotSupportedDecline), style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension RootViewController: DimAnimatorDelegate {
    func animatorDidTapOnDimView(animator: Animator) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: RateAppViewControllerDelegate {
    func rateAppWantsDismiss(viewController: RateAppViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: NotificationsAccessViewControllerDelegate {
    func notificationsAccessWantsDismiss(viewController: NotificationsAccessViewController) {
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}