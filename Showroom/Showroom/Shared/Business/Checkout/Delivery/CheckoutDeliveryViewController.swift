import UIKit

class CheckoutDeliveryViewController: UIViewController, CheckoutDeliveryViewDelegate {

    let resolver: DiResolver
    var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }
    
    let clientAddresses = [
        "Jan Kowalski\nal. Sikorskiego 12/30\n15-888 Białystok\ntel. +48 501 123 456",
        "Anna Kowalska\nul. Wyszyńskiego 18/64\n02-758 Warszawa\ntel. +48 788 888 999"
    ]
    
    let addressFormFields: [AddressFormField] = [.FirstName, .LastName, .StreetAndApartmentNumbers, .PostalCode, .City, .Phone]
    
    let pickedKioskAddress = "Białystok, ul. Stroma 28"
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {        
        view = CheckoutDeliveryView(addressInput: .Options(addresses: clientAddresses), delivery: .Kiosk(address: pickedKioskAddress))
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
        let toAddress = clientAddresses[addressIndex]
        print("did select address at index: \(addressIndex), address: \(toAddress)")
    }
    
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView) {
        print("did tap add address button")
    }
    
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView) {
        print("did tap edit address button")
    }
    
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView) {
        print("did tap choose kiosk button")
    }
    
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView) {
        print("did tap change kiosk button")
    }
    
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowCheckoutSummary))
    }
}
