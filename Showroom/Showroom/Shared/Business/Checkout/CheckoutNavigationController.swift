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
        
        // TODO: Remove when delivery view is ready
        let summaryViewController = resolver.resolve(CheckoutSummaryViewController.self)
        summaryViewController.navigationItem.title = tr(.CheckoutSummaryNavigationHeader)
        summaryViewController.applyBlackBackButton(target: self, action: #selector(CheckoutNavigationController.didTapBackButton))
        pushViewController(summaryViewController, animated: true)
    }
    
    func didTapCloseButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapBackButton(sender: UIBarButtonItem) {
        popViewControllerAnimated(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
