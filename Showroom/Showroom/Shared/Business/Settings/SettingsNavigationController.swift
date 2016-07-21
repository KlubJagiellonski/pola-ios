import UIKit

class SettingsNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private let navigationDelegateHandler = CommonNavigationControllerDelegateHandler()
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        delegate = navigationDelegateHandler
        
        navigationBar.applyTranslucentStyle()
        setNavigationBarHidden(true, animated: false)
        let settingsViewController = resolver.resolve(SettingsViewController.self)
        settingsViewController.resetBackTitle()
        viewControllers = [settingsViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapBackButton() {
        popViewControllerAnimated(true)
    }

    func showUserInfoView(user user: User) {
        logInfo("showUserInfoView")
        let viewController = resolver.resolve(UserInfoViewController.self, argument: user)
        viewController.navigationItem.title = tr(.SettingsUserData)
        pushViewController(viewController, animated: true)
    }
    
    func showHistoryOfOrderView() {
        logInfo("showHistoryOfOrderView")
        let viewController = resolver.resolve(HistoryOfOrderViewController.self)
        viewController.navigationItem.title = tr(.SettingsHistory)
        pushViewController(viewController, animated: true)
    }
    
    func showWebView(title title: String, url: String) {
        let viewController = resolver.resolve(SettingsWebViewController.self, argument: url)
        viewController.navigationItem.title = title
        pushViewController(viewController, animated: true)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .ShowHistoryOfOrder:
                showHistoryOfOrderView()
                return true
            case .Back:
                didTapBackButton()
                return true
            default:
                return false
            }
        case let userInfoEvent as ShowUserInfoViewEvent:
            showUserInfoView(user: userInfoEvent.user)
            return true
            
        case let webViewEvent as ShowSettingsWebViewEvent:
            showWebView(title: webViewEvent.title, url: webViewEvent.url)
            return true
        default:
            return false
        }
    }
}

extension SettingsNavigationController: MainTabChild {
    func popToFirstView() {
        popToRootViewControllerAnimated(true)
    }
}