import Foundation
import UIKit

class SettingsViewController: UIViewController {
    let productActionHeight = CGFloat(216)

    let incrementBadgeButton = UIButton()
    let decrementBadgeButton = UIButton()
    let showToastsButton = UIButton()
    let showLoginButton = UIButton()
    
    let dropUpAnimator: DropUpActionAnimator
    
    let toastManager: ToastManager
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        toastManager = resolver.resolve(ToastManager.self)
        dropUpAnimator = DropUpActionAnimator(height: productActionHeight)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incrementBadgeButton.setTitle("BASKET BADGE +1", forState: .Normal)
        incrementBadgeButton.applySimpleBlueStyle()
        incrementBadgeButton.addTarget(self, action: #selector(SettingsViewController.incrementButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(incrementBadgeButton)
        
        decrementBadgeButton.setTitle("BASKET BADGE -1", forState: .Normal)
        decrementBadgeButton.applySimpleBlueStyle()
        decrementBadgeButton.addTarget(self, action: #selector(SettingsViewController.decrementButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(decrementBadgeButton)
        
        showToastsButton.setTitle("SHOW TOASTS", forState: .Normal)
        showToastsButton.applySimpleBlueStyle()
        showToastsButton.addTarget(self, action: #selector(SettingsViewController.showToastsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(showToastsButton)
        
        showLoginButton.setTitle("SHOW LOGIN", forState: .Normal)
        showLoginButton.applySimpleBlueStyle()
        showLoginButton.addTarget(self, action: #selector(SettingsViewController.showLoginButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(showLoginButton)
        
        configureCustomConstraints()
    }
    
    func toggleTabBar(sender: UIButton!) {
        if (tabBarController as! MainTabViewController).appearance == .Visible {
            (tabBarController as! MainTabViewController).updateTabBarAppearance(.Hidden, animationDuration: 0.3)
        } else {
            (tabBarController as! MainTabViewController).updateTabBarAppearance(.Visible, animationDuration: 0.3)
        }
    }
    
    func incrementButtonPressed(sender: UIButton!) {
        (tabBarController as! MainTabViewController).basketBadgeValue += 1
    }
    
    func decrementButtonPressed(sender: UIButton!) {
        guard (tabBarController as! MainTabViewController).basketBadgeValue > 0 else { return }
        (tabBarController as! MainTabViewController).basketBadgeValue -= 1
    }
    
    func showToastsButtonPressed(sender: UIButton!) {
        toastManager.showMessages(["Poniższe produkty zostały usunięte z listy, ponieważ już nie są dostępne:\n- Spódnica maxi The Never Bloom", "Niestety ceny niektórych produktów uległy zmianie"])
        toastManager.showMessages(["Lorem ipsum dolor sit amet"])
        toastManager.showMessages(["Lorem ipsum dolor sit amet, consectetur adipiscing elit"])
        toastManager.showMessages(["Lorem ipsum dolor sit amet, consectetur adipiscing elit", ", sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris ", "nisi ut aliquip ex ea commodo consequat"])
    }
    
    func showLoginButtonPressed(sender: UIButton) {
        let viewController = resolver.resolve(LoginNavigationController.self)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func configureCustomConstraints() {
        incrementBadgeButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }

        decrementBadgeButton.snp_makeConstraints { make in
            make.top.equalTo(incrementBadgeButton.snp_bottom)
            make.centerX.equalToSuperview()
        }
        
        showToastsButton.snp_makeConstraints { make in
            make.top.equalTo(decrementBadgeButton.snp_bottom)
            make.centerX.equalToSuperview()
        }
        
        showLoginButton.snp_makeConstraints { make in
            make.top.equalTo(showToastsButton.snp_bottom)
            make.centerX.equalToSuperview()
        }
    }
}