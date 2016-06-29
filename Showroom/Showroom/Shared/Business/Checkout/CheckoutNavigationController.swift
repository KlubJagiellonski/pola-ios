import UIKit

class CheckoutNavigationController: UINavigationController, NavigationHandler, EditAddressViewControllerDelegate {
    private let resolver: DiResolver
    private let model: CheckoutModel
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(CheckoutModel.self)
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
        let summaryViewController = resolver.resolve(CheckoutSummaryViewController.self, argument: model)
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
    
    func showEditKioskView(clientAddress clientAddress: [AddressFormField]) {
        let editKioskViewController = resolver.resolve(EditKioskViewController.self, argument: clientAddress)
        editKioskViewController.delegate = self
        editKioskViewController.navigationItem.title = tr(.CheckoutDeliveryNavigationHeader)
        editKioskViewController.applyBlackBackButton(target: self, action: #selector(CheckoutNavigationController.didTapBackButton))
        pushViewController(editKioskViewController, animated: true)
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
            
        case let editKioskEvent as ShowEditKioskEvent:
            showEditKioskView(clientAddress: editKioskEvent.clientAddress)
            return true
            
        default:
            return false
        }
    }
    
    // MARK: - EditAddressViewControllerDelegate
    
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

extension CheckoutNavigationController: EditKioskViewControllerDelegate {
    
    func editKioskViewControllerDidChooseKiosk(viewController: EditKioskViewController, kiosk: Kiosk) {
        
        guard let deliveryViewController = viewControllers.find({ $0 is CheckoutDeliveryViewController }) as? CheckoutDeliveryViewController else { return }
        deliveryViewController.delivery = .Kiosk(address: "\(kiosk.city), \(kiosk.street)")
        deliveryViewController.castView.updateStackView(deliveryViewController.addressInput, delivery: deliveryViewController.delivery, didAddAddress: deliveryViewController.didAddAddress)
        popViewControllerAnimated(true)
    }
}
