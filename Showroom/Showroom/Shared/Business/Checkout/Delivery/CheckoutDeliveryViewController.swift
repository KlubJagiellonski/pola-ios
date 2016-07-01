import UIKit
import RxSwift

enum CheckoutDeliveryEditingState {
    case Edit, Add
}

class CheckoutDeliveryViewController: UIViewController, CheckoutDeliveryViewDelegate {

    var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }
    
    var clientAddresses: [[AddressFormField]]
    private var didAddAddress = false
    
    let pickedKioskAddress = "Białystok, ul. Stroma 28"
    let delivery: Delivery
    let defaultCountry: String
    
    let resolver: DiResolver
    
    init(resolver: DiResolver, basketManager: BasketManager) {
        self.resolver = resolver
        self.delivery = .Kiosk(address: pickedKioskAddress)
        defaultCountry = basketManager.state.deliveryCountry!.name
        clientAddresses = [
            [.FirstName(value: "Jan"), .LastName(value: "Kowalski"), .StreetAndApartmentNumbers(value: "Sikorskiego 12/30"), .PostalCode(value: "15-888"), .City(value: "Białystok"), .Country(defaultValue: defaultCountry), .Phone(value: "+48 501 123 456")],
            [.FirstName(value: "Anna"), .LastName(value: "Kowalska"), .StreetAndApartmentNumbers(value: "Wyszyńskiego 18/64"), .PostalCode(value: "02-758"), .City(value: "Warszawa"), .Country(defaultValue: defaultCountry), .Phone(value: "+48 788 888 999")]
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
        print("did select address at index: \(addressIndex), address: \(clientAddresses[addressIndex])")
    }
    
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView) {
        let emptyAddress: [AddressFormField] = [.FirstName(value: nil), .LastName(value: nil), .StreetAndApartmentNumbers(value: nil), .PostalCode(value: nil), .City(value: nil), .Country(defaultValue: defaultCountry), .Phone(value: nil)]
        sendNavigationEvent(ShowEditAddressEvent(formFields: emptyAddress, editingState: .Add))
    }
    
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView) {
        let lastAddress: [AddressFormField] = clientAddresses.last!
        sendNavigationEvent(ShowEditAddressEvent(formFields: lastAddress, editingState: .Edit))
    }
    
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView) {
        print("did tap choose kiosk button")
    }
    
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView) {
        print("did tap change kiosk button")
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
        castView.selectedAddressIndex = clientAddresses.count - 1
    }
    
    func updateLastAddress(addressFields: [AddressFormField]) {
        clientAddresses[clientAddresses.count-1] = addressFields
        castView.updateStackView(.Options(addresses: clientAddresses), delivery: delivery, didAddAddress: didAddAddress)
        castView.selectedAddressIndex = clientAddresses.count - 1
    }
    

}
