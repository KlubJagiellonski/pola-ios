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
    
    func showWebView(title title: String, webType: SettingsWebType) {
        logInfo("Show web view with title \(title), webType \(webType)")
        let viewController = resolver.resolve(SettingsWebViewController.self, argument: webType)
        viewController.navigationItem.title = title
        pushViewController(viewController, animated: true)
    }
    
    func showSettingsPlatformSelection() {
        logInfo("Show settings platform selection")
        let viewController = resolver.resolve(SettingsPlatformSelectionViewController.self)
        viewController.navigationItem.title = tr(.SettingsPlatformSelection)
        pushViewController(viewController, animated: true)

    }
    
    // MARK:- NavigationHandler
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let webViewEvent as ShowSettingsWebViewEvent:
            showWebView(title: webViewEvent.title, webType: webViewEvent.webType)
            return true
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .ShowSettingsPlatformSelection:
                showSettingsPlatformSelection()
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
}

extension SettingsNavigationController: MainTabChild {
    func popToFirstView() {
        logInfo("Popt to first view")
        popToRootViewControllerAnimated(true)
    }
}