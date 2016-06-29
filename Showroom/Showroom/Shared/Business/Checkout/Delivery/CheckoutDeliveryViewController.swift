import UIKit
import RxSwift

enum CheckoutDeliveryEditingState {
    case Edit, Add
}

class CheckoutDeliveryViewController: UIViewController, CheckoutDeliveryViewDelegate {

    var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }
    
    var clientAddresses: [[AddressFormField]] { didSet { addressInput = .Options(addresses: clientAddresses) } }
    var delivery: Delivery
    let pickedKioskAddress: String? = nil
    let defaultCountry: String
    
    private(set) var addressInput: AddressInput {
        get { return castView.addressInput }
        set { castView.addressInput = newValue }
    }
    private var selectedAddressIndex: Int {
        get { return castView.selectedAddressIndex }
        set { castView.selectedAddressIndex = newValue }
    }
    private(set) var didAddAddress = false
    private var currentAddress: [AddressFormField] {
        switch addressInput {
        case .Options(let addresses): return addresses[selectedAddressIndex]
        case .Form: return castView.formFieldsViews!.map { $0.addressField }
        }
    }
    
    let resolver: DiResolver
    
    init(resolver: DiResolver, basketManager: BasketManager) {
        self.resolver = resolver
        self.delivery = .Kiosk(address: pickedKioskAddress)
        defaultCountry = basketManager.state.deliveryCountry!.name
        clientAddresses = [
            [.FirstName(value: "Jan"), .LastName(value: "Kowalski"), .StreetAndApartmentNumbers(value: "Sikorskiego 12/30"), .PostalCode(value: "15-888"), .City(value: "Białystok"), .Country(defaultValue: defaultCountry), .Phone(value: "+48 501 123 456")],
            [.FirstName(value: "Anna"), .LastName(value: "Kowalska"), .StreetAndApartmentNumbers(value: "Piękna 5/10"), .PostalCode(value: "02-758"), .City(value: "Warszawa"), .Country(defaultValue: defaultCountry), .Phone(value: "+48 788 888 999")]
        ]
       
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let addressInput: AddressInput
        if clientAddresses.count > 0 {
            addressInput = .Options(addresses: clientAddresses)
        } else {
            addressInput = .Form(fields: [.FirstName(value: nil), .LastName(value: nil), .StreetAndApartmentNumbers(value: nil), .PostalCode(value: nil), .City(value: nil), .Country(defaultValue: defaultCountry), .Phone(value: nil)])
        }
        
        view = CheckoutDeliveryView(addressInput: addressInput, delivery: delivery, didAddAddress: didAddAddress)
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
    
    func checkoutDeliveryViewDidSelectAddress(view: CheckoutDeliveryView, atIndex addressIndex: Int) {
        guard case .Options(let addresses) = addressInput else { return }
        logInfo("did select address at index: \(addressIndex), address: \(addresses[addressIndex].map { $0.value })")
    }
    
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView) {
        let emptyAddress: [AddressFormField] = [.FirstName(value: nil), .LastName(value: nil), .StreetAndApartmentNumbers(value: nil), .PostalCode(value: nil), .City(value: nil), .Country(defaultValue: defaultCountry), .Phone(value: nil)]
        sendNavigationEvent(ShowEditAddressEvent(formFields: emptyAddress, editingState: .Add))
    }
    
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView) {
        guard case .Options(let addresses) = addressInput else { return }
        let lastAddress: [AddressFormField] = addresses.last!
        sendNavigationEvent(ShowEditAddressEvent(formFields: lastAddress, editingState: .Edit))
    }
    
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(ShowEditKioskEvent(clientAddress: currentAddress))
    }
    
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(ShowEditKioskEvent(clientAddress: currentAddress))
    }
    
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView) {
        guard view.validate(showResult: true) else {
            return
        }
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowCheckoutSummary))
    }
    
    func addAddress(addressFields: [AddressFormField]) {
        clientAddresses.append(addressFields)
        didAddAddress = true
        castView.updateStackView(.Options(addresses: clientAddresses), delivery: delivery, didAddAddress: didAddAddress)
        selectedAddressIndex = clientAddresses.count - 1
    }
    
    func updateLastAddress(addressFields: [AddressFormField]) {
        clientAddresses[clientAddresses.count-1] = addressFields
        castView.updateStackView(.Options(addresses: clientAddresses), delivery: delivery, didAddAddress: didAddAddress)
        selectedAddressIndex = clientAddresses.count - 1
    }
}


