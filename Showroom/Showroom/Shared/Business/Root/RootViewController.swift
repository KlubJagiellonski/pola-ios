import Foundation
import UIKit
import Swinject
import RxSwift

class RootViewController: PresenterViewController, NavigationHandler {
    private let model: RootModel
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    private var urlToHandle: NSURL?
    private lazy var formSheetAnimator: FormSheetAnimator = { [unowned self] in
        let animator = FormSheetAnimator()
        animator.delegate = self
        return animator
    }()
    
    private lazy var onboardingActionAnimator: InAppOnboardingActionAnimator = { [unowned self] in
        return InAppOnboardingActionAnimator(parentViewHeight: self.castView.bounds.height)
    }()
    
    init?(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(RootModel.self)
        super.init(nibName: nil, bundle: nil)
        
        showModal(resolver.resolve(SplashViewController.self), hideContentView: false, animation: nil, completion: nil)
        
        switch model.startChildType {
        case .PlatformSelection:
            showContent(resolver.resolve(PlatformSelectionViewController.self), animation: nil, completion: nil)
        case .Onboarding:
            model.willShowInitialOnboarding()
            showContent(resolver.resolve(InitialOnboardingViewController), animation: nil, completion: nil)
        case .Main:
            showContent(resolver.resolve(MainTabViewController), animation: nil, completion: nil)
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
        logInfo("Handling quick action shortcut \(shortcut)")
        if let mainTabViewController = self.contentViewController as? MainTabViewController {
            mainTabViewController.handleQuickActionShortcut(shortcut)
        } else {
            let mainTabViewController = resolver.resolve(MainTabViewController)
            mainTabViewController.handleQuickActionShortcut(shortcut)
            showContent(mainTabViewController, animation: nil, completion: nil)
        }
    }
    
    var shouldShowCustomAlert: Bool {
        return self.presentedViewController == nil && contentViewController is MainTabViewController
    }
    
    private func showRateAppViewIfNeeded() -> Bool {
        guard model.rateAppManager.shouldShowRateAppView && shouldShowCustomAlert else {
            logInfo("Could not show rate app view")
            return false
        }
        logInfo("Showing rate app view")
        
        let viewController = self.resolver.resolve(RateAppViewController.self, argument: RateAppViewType.AfterTime)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        model.rateAppManager.didShowRateAppView()
        return true
    }
    
    private func showNotificationAccessView() {
        guard shouldShowCustomAlert else {
            logInfo("Could not show notification access view")
            return
        }
        logInfo("Showing notification access view")
        
        let viewController = self.resolver.resolve(NotificationsAccessViewController.self, argument: NotificationsAccessViewType.AfterTime)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        model.notificationManager.didShowNotificationsAccessView()
    }
    
    private func showUpdateAlert(withImageUrl imageUrl: String?) {
        guard shouldShowCustomAlert else {
            logInfo("Could not show update alert view")
            return
        }
        logInfo("Showing update alert")
        
        let viewController = self.resolver.resolve(UpdateAppViewController.self, argument: imageUrl)
        viewController.delegate = self
        formSheetAnimator.presentViewController(viewController, presentingViewController: self)
        model.versionManager.didShowVersionAlert()
    }
    
    func showInitialOnboarding() {
        guard !(contentViewController is InitialOnboardingViewController) else { return }
        
        model.willShowInitialOnboarding()
        
        let initialOnboardingViewController = resolver.resolve(InitialOnboardingViewController)
        showContent(initialOnboardingViewController, animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
    }
    
    func showDashboard() {
        if let currentMainTabViewController = self.contentViewController as? MainTabViewController {
            currentMainTabViewController.updateSelectedIndex(forControllerType: MainTabChildControllerType.Dashboard)
        } else {
            model.shouldSkipStartScreen = true
            
            let mainTabViewController = resolver.resolve(MainTabViewController)
            showContent(mainTabViewController, animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            if let urlToHandle = urlToHandle {
                mainTabViewController.handleOpen(withURL: urlToHandle)
                self.urlToHandle = nil
            }
        }
    }
    
    func showInAppPagingOnboarding() -> Bool {
        if self.presentedViewController != nil {
            return false
        }
        
        logInfo("Showing in app paging onboarding")
        let pagingOnboardingViewController = PagingInAppOnboardingViewController()
        pagingOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(pagingOnboardingViewController, presentingViewController: self)
        return true
    }
    
    func showInAppWishlistOnboarding() -> Bool {
        if self.presentedViewController != nil {
            return false
        }
        
        logInfo("Show in-app wishlist onboarding")
        let wishlistOnboardingViewController = WishlistInAppOnboardingViewController()
        wishlistOnboardingViewController.delegate = self
        onboardingActionAnimator.presentViewController(wishlistOnboardingViewController, presentingViewController: self)
        return true
    }
    
    // MARK: - NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        guard let simpleEvent = event as? SimpleNavigationEvent else { return false }
        
        switch simpleEvent.type {
            
        case .SplashEnd:
            logInfo("Splash end")
            hideModal(animation: nil) { [weak self] _ in
                guard let `self` = self else { return }
                if !self.showRateAppViewIfNeeded() && self.model.notificationManager.shouldAskForRemoteNotifications {
                    self.showNotificationAccessView()
                }
                if self.model.shouldSkipStartScreen {
                    self.model.versionManager.fetchLatestVersion()
                        .subscribeNext { [weak self](appVersion: AppVersion) in
                            guard let `self` = self else { return }
                            if self.model.versionManager.shouldShowUpdateAlert {
                                self.showUpdateAlert(withImageUrl: appVersion.promoImageUrl)
                            }
                    }.addDisposableTo(self.disposeBag)
                }
            }
            return true
            
        case .ShowInitialPlatformSelection:
            logInfo("Show initial platform selection")
            guard !(contentViewController is PlatformSelectionViewController) else {
                return true
            }
            showContent(resolver.resolve(PlatformSelectionViewController.self), animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
            return true
            
        case .PlatformSelectionEnd:
            logInfo("Platform selection end")
            if !model.shouldSkipStartScreen {
                showInitialOnboarding()
                return true
            } else {
                model.shouldSkipStartScreen = true
                
                let mainTabViewController = resolver.resolve(MainTabViewController.self)
                showContent(mainTabViewController, animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
                return true
            }
            
        case .ShowOnboarding:
            logInfo("Show onboarding")
            showInitialOnboarding()
            return true

        case .OnboardingEnd:
            logInfo("Onboarding end")
            if model.shouldSelectGender {
                // user must not be able to set gender
                // gender will be set to default value: woman in UserManager
                showDashboard()
                return true
            } else {
                guard !(contentViewController is StartViewController) else { return true }
                showContent(resolver.resolve(StartViewController), animation: DimTransitionAnimation(animationDuration: 0.3), completion: nil)
                return true
            }
            
        case .ShowDashboard:
            logInfo("Showing dashboard")
            showDashboard()
            return true
            
        case .ShowProductDetailsInAppOnboarding:
            logInfo("Show product details in app onboarding")
            if !model.userSeenPagingInAppOnboarding {
                if showInAppPagingOnboarding() {
                    model.userSeenPagingInAppOnboarding = true
                }
            }
            return true
            
        case .ShowProductListInAppOnboarding:
            logInfo("Show product list in app onboarding")            
            if !model.userSeenWishlistInAppOnboarding {
                if showInAppWishlistOnboarding() {
                    model.userSeenWishlistInAppOnboarding = true
                }
            }
            return true
            
        case .AskForNotificationsFromWishlist:
            logInfo("Ask for notificaiton from wishlsit")
            // Only happens when the user adds something to the wishlist.
            if model.notificationManager.shouldShowNotificationsAccessViewFromWishlist {
                showNotificationAccessView()
            }
            return true
            
        default:
            return false
        }
    }
}

extension RootViewController: DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool {
        logInfo("Handling open with url \(url)")
        if let mainTabViewController = self.contentViewController as? MainTabViewController {
            return mainTabViewController.handleOpen(withURL: url)
        } else if model.shouldSkipStartScreen {
            let mainTabViewController = resolver.resolve(MainTabViewController.self)
            showContent(mainTabViewController, animation: nil, completion: nil)
            return mainTabViewController.handleOpen(withURL: url)
        } else {
            logInfo("Onboarding or start view not finished yet. Postponing url handling")
            //wait with handling till app finish onboarding and start
            urlToHandle = url
            return true
        }
    }
}

extension RootViewController: ApiServiceDelegate {
    func apiServiceDidReceiveAppNotSupportedError(api: ApiService) {
        guard presentedViewController == nil else { return }
        
        logInfo("Received app not support error. Showing alert")
        
        let acceptAction: (UIAlertAction -> Void) = { [weak self]_ in
            logInfo("Showing app store")
            if let appStoreURL = self?.model.appStoreURL {
                UIApplication.sharedApplication().openURL(appStoreURL)
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
        logInfo("Did tap on dim view")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: RateAppViewControllerDelegate {
    func rateAppWantsDismiss(viewController: RateAppViewController) {
        logInfo("Rate app wants dismiss")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: NotificationsAccessViewControllerDelegate {
    func notificationsAccessWantsDismiss(viewController: NotificationsAccessViewController) {
        logInfo("Notification access wants dismiss")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: UpdateAppViewControllerDelegate {
    func updateAppWantsDismiss(viewController: UpdateAppViewController) {
        logInfo("Update alert wants dismiss")
        formSheetAnimator.dismissViewController(presentingViewController: self)
    }
}

extension RootViewController: PagingInAppOnboardingViewControllerDelegate, WishlistInAppOnboardingViewControllerDelegate {
    func pagingOnboardingViewControllerDidTapDismiss(viewController: PagingInAppOnboardingViewController) {
        logInfo("Paging onboarding did tap dismiss")
        onboardingActionAnimator.dismissViewController(presentingViewController: self)
    }
    
    func wishlistOnboardingViewControllerDidTapDismissButton(viewController: WishlistInAppOnboardingViewController) {
        logInfo("Wishlist onboarding did tap dismiss")
        onboardingActionAnimator.dismissViewController(presentingViewController: self)
    }
}
