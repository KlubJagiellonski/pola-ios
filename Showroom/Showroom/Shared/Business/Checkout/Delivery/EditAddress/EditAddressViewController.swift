import UIKit

protocol EditAddressViewControllerDelegate: class {
    func editAddressViewControllerDidAddAddress(viewController: EditAddressViewController, savedAddressFields: [AddressFormField])
    func editAddressViewControllerDidUpdateAddress(viewController: EditAddressViewController, savedAddressFields: [AddressFormField])
}

class EditAddressViewController: UIViewController, EditAddressViewDelegate {
    
    let resolver: DiResolver
    var castView: EditAddressView { return view as! EditAddressView }
    
    let editingState: CheckoutDeliveryEditingState
    let initialFormFields: [AddressFormField]
    
    weak var delegate: EditAddressViewControllerDelegate?
    
    init(resolver: DiResolver, formFields: [AddressFormField], editingState: CheckoutDeliveryEditingState) {
        self.resolver = resolver
        self.initialFormFields = formFields
        self.editingState = editingState
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = EditAddressView(formFields: initialFormFields)
        castView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.registerOnKeyboardEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.unregisterOnKeyboardEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editAddressViewDidTapSaveButton(view: EditAddressView, savedAddressFields: [AddressFormField]) {
        switch editingState {
        case .Add:
            delegate?.editAddressViewControllerDidAddAddress(self, savedAddressFields: savedAddressFields)
        case .Edit:
            delegate?.editAddressViewControllerDidUpdateAddress(self, savedAddressFields: savedAddressFields)
        }
    }
}