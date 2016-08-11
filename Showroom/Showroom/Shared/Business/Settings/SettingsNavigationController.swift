import UIKit

class SettingsNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver
    private let navigationDelegateHandler = CommonNavigationControllerDelegateHandler(hideNavigationBarForFirstView: true)
    
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
    
    func showWebView(title title: String, webType: SettingsWebType) {
        let viewController = resolver.resolve(SettingsWebViewController.self, argument: webType)
        viewController.navigationItem.title = title
        pushViewController(viewController, animated: true)
    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let webViewEvent as ShowSettingsWebViewEvent:
            showWebView(title: webViewEvent.title, webType: webViewEvent.webType)
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