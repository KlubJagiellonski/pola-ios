import UIKit
import RxSwift

class CheckoutDeliveryViewController: UIViewController, CheckoutDeliveryViewDelegate {
    private let disposeBag = DisposeBag()
    private var castView: CheckoutDeliveryView { return view as! CheckoutDeliveryView }
    private let checkoutModel: CheckoutModel
    private let toastManager: ToastManager
    
    init(with checkoutModel: CheckoutModel, and toastManager: ToastManager) {
        self.checkoutModel = checkoutModel
        self.toastManager = toastManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CheckoutDeliveryView(checkoutState: checkoutModel.state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutDelivery)
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
    
    func markLastAddressOptionAsSelected() {
        let index = checkoutModel.state.userAddresses.count - 1
        let address = checkoutModel.state.userAddresses[index]
        castView.selectedAddressIndex = index
        checkoutModel.state.selectedAddress = address
    }
    
    private func showSummaryIfPossible() {
        if checkoutModel.state.checkout.deliveryCarrier.id == .RUCH && checkoutModel.state.selectedKiosk == nil {
            sendShowEditKioskEvent()
            return
        }
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowCheckoutSummary))
    }
    
    private func updateValidationFieldIfNeeded(error: String?, key: String) {
        if let error = error {
            self.castView.updateFieldValidation(withId: key, validation: error)
        }
    }
    
    func checkoutDeliveryViewDidSelectAddress(view: CheckoutDeliveryView, atIndex addressIndex: Int) {
        logInfo("Checkout delivery view did select address at index: \(addressIndex)")
        logAnalyticsEvent(AnalyticsEventId.CheckoutAddressClicked)
        
        let address = checkoutModel.state.userAddresses[addressIndex]
        checkoutModel.state.selectedAddress = address
    }
    
    private func createEditKioskEntry() -> EditKioskEntry {
        return EditKioskEntry(entryStreetAndAppartmentNumbers: castView.streetAndApartmentNumbersValue, entryCity: castView.cityValue)
    }
    
    private func sendShowEditKioskEvent() {
        sendNavigationEvent(ShowEditKioskEvent(editKioskEntry: createEditKioskEntry()))
    }
    
    // MARK:- CheckoutDeliveryViewDelegate
    
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView) {
        logInfo("Checkout delivery view did tap add address button")
        logAnalyticsEvent(AnalyticsEventId.CheckoutAddNewAddressClicked)
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowEditAddress))
    }
    
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView) {
        logInfo("Checkout delivery view did tap edit address button")
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowEditAddress))
    }
    
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView) {
        logInfo("Checkout delivery view did tap choose kiosk button")
        logAnalyticsEvent(AnalyticsEventId.CheckoutChosePOPClicked)
        sendShowEditKioskEvent()
    }
    
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView) {
        logInfo("Checkout delivery view did tap change kiosk button")
        logAnalyticsEvent(AnalyticsEventId.CheckoutChosePOPClicked)
        sendShowEditKioskEvent()
    }
    
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView) {
        logInfo("Checkout delivery view did tap next button")
        guard view.validate(showResult: true) else {
            logInfo("Checkout delivery view validation failed")
            castView.scrollContentToTop()
            return
        }
        
        logAnalyticsEvent(AnalyticsEventId.CheckoutNextClicked)
        
        if checkoutModel.state.isFormMode {
            guard let newUserAddress = castView.userAddress else { return }
            castView.changeSwitcherState(.ModalLoading)
            
            checkoutModel.update(with: newUserAddress).subscribe { [weak self](event: Event<UserAddress>) in
                guard let `self` = self else { return }
                
                self.castView.changeSwitcherState(.Success)
                
                switch event {
                case .Next(_):
                    self.showSummaryIfPossible()
                case .Error(let error):
                    logError("Error during login: \(error)")
                    switch error {
                    case ApiError.NoSession, ApiError.LoginRetryFailed:
                        logInfo("User did logged out, closing checkout")
                        self.toastManager.showMessage(tr(.CommonUserLoggedOut))
                        self.sendNavigationEvent(SimpleNavigationEvent(type: .Close))
                    case EditAddressError.ValidationFailed(let fieldsErrors):
                        self.castView.scrollContentToTop()
                        self.updateValidationFieldIfNeeded(fieldsErrors.firstName, key: UserAddress.firstNameKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.lastName, key: UserAddress.lastNameKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.city, key: UserAddress.cityKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.country, key: UserAddress.countryKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.phone, key: UserAddress.phoneKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.postalCode, key: UserAddress.postalCodeKey)
                        self.updateValidationFieldIfNeeded(fieldsErrors.streetAndAppartmentNumbers, key: UserAddress.streetAndAppartmentNumbersKey)
                    case EditAddressError.Unknown:
                        fallthrough
                    default:
                        logInfo("Unknown error")
                        self.toastManager.showMessage(tr(.CommonError))
                    }
                default: break
                }
            }.addDisposableTo(disposeBag)
        } else {
            showSummaryIfPossible()
        }
    }
    
    func checkoutDeliveryViewDidReachFormEnd(view: CheckoutDeliveryView) {
        guard checkoutModel.state.selectedKiosk == nil else {
            return
        }
        sendShowEditKioskEvent()
    }
}

