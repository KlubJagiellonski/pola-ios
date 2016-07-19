import UIKit
import RxSwift

class CheckoutDeliveryViewController: UIViewController, CheckoutDeliveryViewDelegate {

    var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }

    private let checkoutModel: CheckoutModel
    
    
    init(with checkoutModel: CheckoutModel) {
        self.checkoutModel = checkoutModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CheckoutDeliveryView(checkoutState: checkoutModel.state)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        logInfo("did select address at index: \(addressIndex)")
        let address = checkoutModel.state.userAddresses[addressIndex]
        checkoutModel.state.selectedAddress = address
    }
    
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(ShowEditAddressEvent(userAddress: nil))
    }
    
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView) {
        guard let address = checkoutModel.state.userAddresses.last else { return }
        sendNavigationEvent(ShowEditAddressEvent(userAddress: address))
    }
    
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowEditKiosk))
    }
    
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowEditKiosk))
    }
    
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView) {
        guard view.validate(showResult: true) else {
            return
        }
        if checkoutModel.state.checkout.deliveryCarrier.id == .RUCH && checkoutModel.state.selectedKiosk == nil {
            sendNavigationEvent(SimpleNavigationEvent(type: .ShowEditKiosk))
            return
        }
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowCheckoutSummary))
    }
}

