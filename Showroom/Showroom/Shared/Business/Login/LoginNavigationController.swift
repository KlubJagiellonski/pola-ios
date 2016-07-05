import UIKit

class LoginNavigationController: UINavigationController, NavigationHandler {
    let resolver: DiResolver

    init(resolver: DiResolver) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhiteStyle()
        
        let loginViewController = resolver.resolve(LoginViewController.self)
        loginViewController.navigationItem.title = tr(.LoginNavigationHeader)
        loginViewController.applyBlackCloseButton(target: self, action: #selector(LoginNavigationController.didTapCloseButton))
        viewControllers = [loginViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCloseButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapBackButton(sender: UIBarButtonItem) {
        popViewControllerAnimated(true)
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        guard let simpleEvent = event as? SimpleNavigationEvent else { return false }
        
        switch simpleEvent.type {
        case .Back:
            popViewControllerAnimated(true)
            return true
        case .ShowRegistration:
            let registrationViewController = resolver.resolve(RegistrationViewController.self)
            registrationViewController.navigationItem.title = tr(.RegistrationNavigationHeader)
            registrationViewController.applyBlackBackButton(target: self, action: #selector(LoginNavigationController.didTapBackButton))
            pushViewController(registrationViewController, animated: true)
            return true
        default: return false
        }
    }
}
