import UIKit

//TODO: delegate

class CheckoutNavigationController: UINavigationController, NavigationHandler, EditAddressViewControllerDelegate {
    
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.applyWhiteStyle()
        
        let checkoutDeliveryViewController = resolver.resolve(CheckoutDeliveryViewController.self, argument: resolver.resolve(BasketManager.self))
        checkoutDeliveryViewController.navigationItem.title = tr(.CheckoutDeliveryNavigationHeader)
        
        checkoutDeliveryViewController.applyBlackCloseButton(target: self, action: #selector(CheckoutNavigationController.didTapCloseButton))
        
        viewControllers = [checkoutDeliveryViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSummaryView() {
        let summaryViewController = resolver.resolve(CheckoutSummaryViewController.self)
        summaryViewController.navigationItem.title = tr(.CheckoutSummaryNavigationHeader)
        summaryViewController.applyBlackBackButton(target: self, action: #selector(CheckoutNavigationController.didTapBackButton))
        pushViewController(summaryViewController, animated: true)
    }
    
    func showEditAddressView(formFields formFields: [AddressFormField], editingState: CheckoutDeliveryEditingState) {
        let editAddressViewController = resolver.resolve(EditAddressViewController.self, arguments: (formFields, editingState))
        editAddressViewController.delegate = self
        editAddressViewController.navigationItem.title = tr(.CheckoutDeliveryEditAddressNavigationHeader)
        editAddressViewController.applyBlackBackButton(target: self, action: #selector(CheckoutNavigationController.didTapBackButton))
        pushViewController(editAddressViewController, animated: true)
    }
    
    func didTapCloseButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapBackButton(sender: UIBarButtonItem) {
        popViewControllerAnimated(true)
    }
    
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        switch event {
        case let simpleEvent as SimpleNavigationEvent:
            switch simpleEvent.type {
            case .ShowCheckoutSummary:
                showSummaryView()
                return true
            default:
                return false
            }
            
        case let editAddressEvent as ShowEditAddressEvent:
            showEditAddressView(formFields: editAddressEvent.formFields, editingState: editAddressEvent.editingState)
            return true
        default:
            return false
        }
    }
    
    func editAddressViewControllerDidAddAddress(viewController: EditAddressViewController, savedAddressFields: [AddressFormField]) {
        guard let deliveryViewController = viewControllers.find({ $0 is CheckoutDeliveryViewController }) as? CheckoutDeliveryViewController else { return }
        deliveryViewController.addAddress(savedAddressFields)
        popViewControllerAnimated(true)
    }
    
    func editAddressViewControllerDidUpdateAddress(viewController: EditAddressViewController, savedAddressFields: [AddressFormField]) {
        guard let deliveryViewController = viewControllers.find({ $0 is CheckoutDeliveryViewController }) as? CheckoutDeliveryViewController else { return }
        deliveryViewController.updateLastAddress(savedAddressFields)
        popViewControllerAnimated(true)
    }
}
