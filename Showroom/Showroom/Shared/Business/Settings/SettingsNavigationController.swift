import UIKit

class SettingsNavigationController: UINavigationController {
    private let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        let settingsViewController = resolver.resolve(SettingsViewController.self)
        viewControllers = [settingsViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapBackButton() {
        popViewControllerAnimated(true)
    }
}

extension SettingsNavigationController: MainTabChild {
    func popToFirstView() {
        popToRootViewControllerAnimated(true)
    }
}