import UIKit
import RxSwift

protocol EditAddressViewControllerDelegate: class {
    func editAddressViewControllerWantsDismiss(viewController: EditAddressViewController)
}

class EditAddressViewController: UIViewController, EditAddressViewDelegate {
    private let disposeBag = DisposeBag()
    private var castView: EditAddressView { return view as! EditAddressView }
    private let checkoutModel: CheckoutModel
    private let toastManager: ToastManager
    
    weak var delegate: EditAddressViewControllerDelegate?
    
    init(with checkoutModel: CheckoutModel, and resolver: DiResolver, and toastManager: ToastManager) {
        self.checkoutModel = checkoutModel
        self.toastManager = toastManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = EditAddressView(userAddress: checkoutModel.state.editableAddress, defaultCountry: checkoutModel.state.checkout.deliveryCountry.name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.CheckoutDeliveryEditAddress)
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
    
    func editAddressViewDidTapSaveButton(view: EditAddressView) {
        guard castView.validate(showResult: true) else {
            castView.scrollContentToTop()
            return
        }
        guard let newUserAddress = castView.userAddress else { return }
        
        castView.switcherState = .ModalLoading
        
        checkoutModel.update(with: newUserAddress).subscribe { [weak self] (event: Event<UserAddress>) in
            guard let `self` = self else { return }
            
            self.castView.switcherState = .Success
            
            switch event {
            case .Next(_):
                self.delegate?.editAddressViewControllerWantsDismiss(self)
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
                    self.toastManager.showMessage(tr(.CommonError))
                }
            default: break
            }
        }.addDisposableTo(disposeBag)
    }
    
    private func updateValidationFieldIfNeeded(error: String?, key: String) {
        if let error = error {
            self.castView.updateFieldValidation(withId: key, validation: error)
        }
    }
}