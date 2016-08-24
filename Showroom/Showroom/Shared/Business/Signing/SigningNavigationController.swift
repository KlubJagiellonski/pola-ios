import UIKit

enum SigningMode {
    case Login
    case Register
}

protocol SigningNavigationControllerDelegate: class {
    func signingWantsDismiss(navigationController: SigningNavigationController)
    func signingDidLogIn(navigationController: SigningNavigationController)
}

final class SigningNavigationController: UINavigationController, NavigationHandler {
    private let resolver: DiResolver

    weak var signingDelegate: SigningNavigationControllerDelegate?
    
    init(resolver: DiResolver, mode: SigningMode) {
        self.resolver = resolver
        
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhiteStyle()
        
        switch mode {
        case .Login:
            let loginViewController = resolver.resolve(LoginViewController.self)
            loginViewController.navigationItem.title = tr(.LoginNavigationHeader)
            loginViewController.applyBlackCloseButton(target: self, action: #selector(SigningNavigationController.didTapCloseButton))
            loginViewController.resetBackTitle()
            viewControllers = [loginViewController]
            return
        case .Register:
            let registrationViewController = resolver.resolve(RegistrationViewController.self)
            registrationViewController.navigationItem.title = tr(L10n.RegistrationNavigationHeader)
            registrationViewController.applyBlackCloseButton(target: self, action: #selector(SigningNavigationController.didTapCloseButton))
            registrationViewController.resetBackTitle()
            viewControllers = [registrationViewController]
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCloseButton(sender: UIBarButtonItem) {
        logInfo("Did tap close button")
        signingDelegate?.signingWantsDismiss(self)
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        logInfo("Handle navigation event: \(event)")
        guard let simpleEvent = event as? SimpleNavigationEvent else {
            logError("Unexpected event type: \(event)")
            return false
        }
        
        switch simpleEvent.type {
        case .Back:
            popViewControllerAnimated(true)
            return true
        case .Close:
            signingDelegate?.signingDidLogIn(self)
            return true
        case .ShowLogin:
            if viewControllers.count > 1 {
                // There can be only 2 ViewControllers: Login and Register. If we already have both, 
                // there is no need to create a new one. In this case .ShowLogin always comes from the Registration,
                // so we are sure that below is Login. We can pop the Registration to show the Login.
                popViewControllerAnimated(true)
                return true
            }
            
            let loginViewController = resolver.resolve(LoginViewController.self)
            loginViewController.navigationItem.title = tr(.LoginNavigationHeader)
            loginViewController.resetBackTitle()
            pushViewController(loginViewController, animated: true)
            return true
        case .ShowRegistration:
            if viewControllers.count > 1 {
                // We already have Login and Registration view controllers on the stack. 
                // In this case .ShowRegistration always comes from the Login, so we are sure that below is the Registration.
                // We can pop the Login to show the Registration.
                popViewControllerAnimated(true)
                return true
            }
            
            let registrationViewController = resolver.resolve(RegistrationViewController.self)
            registrationViewController.navigationItem.title = tr(.RegistrationNavigationHeader)
            registrationViewController.resetBackTitle()
            pushViewController(registrationViewController, animated: true)
            return true
        case .ShowResetPassword:
            let resetViewController = resolver.resolve(ResetPasswordViewController.self)
            resetViewController.navigationItem.title = tr(L10n.ResetPasswordNavigationHeader)
            resetViewController.resetBackTitle()
            pushViewController(resetViewController, animated: true)
            return true
        case .ShowRules:
            let viewController = resolver.resolve(SettingsWebViewController.self, argument: SettingsWebType.Rules)
            viewController.navigationItem.title = tr(.SettingsRules)
            pushViewController(viewController, animated: true)
            return true
        default: return false
        }
    }
}
