import UIKit

class LoginNavigationController: UINavigationController {
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
}
