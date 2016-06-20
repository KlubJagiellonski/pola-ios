import UIKit

//TODO: delegate

class CheckoutNavigationController: UINavigationController {
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhiteStyle()
        
        let checkoutAddressViewController = resolver.resolve(CheckoutDeliveryViewController.self)
        checkoutAddressViewController.navigationItem.title = tr(.CheckoutDeliveryNavigationHeader)
        
        checkoutAddressViewController.applyBlackCloseButton(target: self, action: #selector(CheckoutNavigationController.didTapCloseButton))
        
        // TODO: add separator
        
        viewControllers = [checkoutAddressViewController]
    }
    
    func didTapCloseButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
