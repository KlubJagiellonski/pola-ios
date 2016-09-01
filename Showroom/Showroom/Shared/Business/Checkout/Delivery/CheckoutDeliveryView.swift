import UIKit
import RxSwift

protocol CheckoutDeliveryViewDelegate: class {
    func checkoutDeliveryViewDidSelectAddress(view: CheckoutDeliveryView, atIndex addressIndex: Int)
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidReachFormEnd(view: CheckoutDeliveryView)
}

class CheckoutDeliveryView: ViewSwitcher {
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nextButton = UIButton()
    
    var contentValidators: [ContentValidator] = []
    let keyboardHelper = KeyboardHelper()
    
    private let disposeBag = DisposeBag()
    private var addressInput: AddressInput
    weak var delegate: CheckoutDeliveryViewDelegate?

    var formFieldsViews: [CheckoutDeliveryInputView]?
    var addressOptionViews: [CheckoutDeliveryAddressOptionView]?
    var selectedAddressIndex: Int! {
        didSet {
            guard case .Options = addressInput else { return }
            updateAddressOptions(selectedIndex: selectedAddressIndex)
        }
    }
    var userAddress: EditUserAddress? {
        return AddressFormField.formFieldsToUserAddress(getAddressFields())
    }
    
    var streetAndApartmentNumbersValue: String? {
        for formField in getAddressFields() {
            switch formField {
            case .StreetAndApartmentNumbers(let value):
                return value
            default: continue
            }
        }
        return nil
    }
    
    var cityValue: String? {
        for formField in getAddressFields() {
            switch formField {
            case .City(let value):
                return value
            default: continue
            }
        }
        return nil
    }
    
    init(checkoutState: CheckoutState) {
        self.addressInput = AddressInput.fromUserAddresses(checkoutState.userAddresses, defaultCountry: checkoutState.checkout.deliveryCountry.name, userFirstName: checkoutState.checkout.user.name, isFormMode: checkoutState.isFormMode)
        super.init(successView: contentView, initialState: .Success)
        
        addValidator(CheckoutValidator())
        
        keyboardHelper.delegate = self
        
        switch addressInput {
        case .Form:
            formFieldsViews = [CheckoutDeliveryInputView]()
        case .Options:
            addressOptionViews = [CheckoutDeliveryAddressOptionView]()
            selectedAddressIndex = 0
        }
        
        checkoutState.userAddressesObservable.subscribeNext { [unowned self] in
            self.updateData($0, checkoutState: checkoutState)
        }.addDisposableTo(disposeBag)
        
        backgroundColor = UIColor(named: .White)
        
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        stackView.axis = .Vertical
        updateStackView(checkoutState)
        scrollView.addSubview(stackView)
        
        nextButton.setTitle(tr(.CheckoutDeliveryNext), forState: .Normal)
        nextButton.addTarget(self, action: #selector(CheckoutDeliveryView.didTapNextButton), forControlEvents: .TouchUpInside)
        nextButton.applyBlueStyle()
        contentView.addSubview(nextButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutDeliveryView.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollContentToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
    }
    
    private func configureCustomCostraints() {
        scrollView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalTo(scrollView.snp_edges).inset(UIEdgeInsetsMake(0, Dimensions.defaultMargin, 0, Dimensions.defaultMargin))
            make.width.equalTo(self).offset(-2 * Dimensions.defaultMargin)
        }
        
        nextButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(scrollView.snp_bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    func registerOnKeyboardEvent() {
        keyboardHelper.register()
    }
    
    func unregisterOnKeyboardEvent() {
        keyboardHelper.unregister()
    }
    
    private func updateData(userAddresses: [UserAddress], checkoutState: CheckoutState) {
        addressInput = AddressInput.fromUserAddresses(userAddresses, defaultCountry: checkoutState.checkout.deliveryCountry.name, userFirstName: checkoutState.checkout.user.name, isFormMode: checkoutState.isFormMode)
        updateStackView(checkoutState)
    }
    
    func updateStackView(checkoutState: CheckoutState) {
        formFieldsViews?.removeAll()
        addressOptionViews?.removeAll()
        contentValidators.removeAll()
        contentValidators.append(CheckoutDeliveryContentValidatorProxy(deliveryView: self))
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        stackView.addArrangedSubview(CheckoutDeliveryLabelView(text: checkoutState.checkout.deliveryCarrier.checkoutHeaderText, topMargin: Dimensions.defaultMargin))
        
        switch addressInput {
        case .Form(let fields):
            for (index, field) in fields.enumerate() {
                let inputView = CheckoutDeliveryInputView(addressField: field)
                inputView.tag = field.fieldId.hashValue
                inputView.inputTextField.tag = index
                inputView.inputTextField.returnKeyType = .Next
                inputView.inputTextField.keyboardType = field.keyboardType
                inputView.inputTextField.delegate = self
                contentValidators.append(inputView)
                stackView.addArrangedSubview(inputView)
                formFieldsViews?.append(inputView)
            }
            
        case .Options(let addresses):
            for address in addresses {
                let addressOptionView = CheckoutDeliveryAddressOptionView(address: stringFromAddressFormFields(address), selected: false)
                addressOptionView.deliveryView = self
                stackView.addArrangedSubview(addressOptionView)
                addressOptionViews?.append(addressOptionView)
            }
            
            let editButtonView = CheckoutDeliveryEditButtonView(editingType: (checkoutState.addressAdded ? .Edit : .Add))
            editButtonView.deliveryView = self
            stackView.addArrangedSubview(editButtonView)
            
            updateAddressOptions(selectedIndex: selectedAddressIndex)
        }
        
        stackView.addArrangedSubview(CheckoutDeliveryLabelView(text: tr(.CheckoutDeliveryDeliveryHeader), topMargin: 0))
        
        let deliveryDetailsView = CheckoutDeliveryDetailsView(checkoutState: checkoutState)
        deliveryDetailsView.deliveryView = self
        stackView.addArrangedSubview(deliveryDetailsView)
    }
    
    func updateAddressOptions(selectedIndex selectedIndex: Int) {
        guard case .Options = addressInput else { return }
        for (index, addressOptionView) in addressOptionViews!.enumerate() {
            addressOptionView.selected = (index == selectedIndex)
        }
    }
    
    func updateFieldValidation(withId id: String, validation: String?) {
        guard let inputView = stackView.arrangedSubviews.find({ $0.tag == id.hashValue }) as? CheckoutDeliveryInputView else {
            return
        }
        inputView.validation = validation
    }
    
    func didTapAddressOptionView(addressOptionView: CheckoutDeliveryAddressOptionView) {
        selectedAddressIndex = addressOptionViews?.indexOf(addressOptionView)
        delegate?.checkoutDeliveryViewDidSelectAddress(self, atIndex: selectedAddressIndex)
    }
    
    func dataSourceDidTapAddAddressButton() {
        delegate?.checkoutDeliveryViewDidTapAddAddressButton(self)
    }
    
    func dataSourceDidTapEditAddressButton() {
        delegate?.checkoutDeliveryViewDidTapEditAddressButton(self)
    }
    
    func dataSourceDidTapChooseKioskButton() {
        delegate?.checkoutDeliveryViewDidTapChooseKioskButton(self)
    }
    
    func dataSourceDidTapChangeKioskButton() {
        delegate?.checkoutDeliveryViewDidTapChooseKioskButton(self)
    }
    
    func didTapNextButton() {
        delegate?.checkoutDeliveryViewDidTapNextButton(self)
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
    
    func stringFromAddressFormFields(formFields: [AddressFormField]) -> String {
        var string = ""
        for addressField in formFields {
            switch addressField {
            case .FirstName(let value?): string += value + " "
            case .LastName(let value?): string += value + "\n"
            case .StreetAndApartmentNumbers(let value?): string += tr(.CheckoutDeliveryAdressStreet) + " " + value + "\n"
            case .PostalCode(let value?): string += value + " "
            case .City(let value?): string += value + "\n"
            case .Phone(let value?): string += tr(.CheckoutDeliveryAdressPhoneNumber) + " " + value + "\n"
            default: break
            }
        }
        return string
    }
    
    private func getAddressFields() -> [AddressFormField] {
        var addressFields = [AddressFormField]()
        for view in stackView.arrangedSubviews {
            if let inputView = view as? CheckoutDeliveryInputView {
                addressFields.append(inputView.addressField)
            }
        }
        return addressFields
    }
}

final class CheckoutDeliveryContentValidatorProxy: ContentValidator {
    weak var deliveryView: CheckoutDeliveryView?
    
    init(deliveryView: CheckoutDeliveryView) {
        self.deliveryView = deliveryView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getValue() -> AnyObject? {
        return deliveryView?.getValue()
    }
    func showError(error: String) {
        deliveryView?.showError(error)
    }
    func hideError() {
        deliveryView?.hideError()
    }
    
    func validate(showResult: Bool) -> Bool {
        return deliveryView?.validate(showResult) ?? false
    }
}

extension CheckoutDeliveryView: ContentValidator {
    func getValue() -> AnyObject? {
        return self
    }
    func showError(error: String) { }
    func hideError() { }
}

extension CheckoutDeliveryView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return handleTextFieldReturn(textField)
    }
}

extension CheckoutDeliveryView: FormView {
    func onFormReachedEnd() {
        dismissKeyboard()
        delegate?.checkoutDeliveryViewDidReachFormEnd(self)
    }
}

extension CheckoutDeliveryView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions, visible: Bool) {
        let bottomOffset = keyboardHelper.retrieveBottomMargin(self, keyboardToFrame: toFrame) - nextButton.bounds.height
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
    }
}

extension DeliveryCarrier {
    private var checkoutHeaderText: String {
        switch id {
        case .RUCH:
            return tr(.CheckoutDeliveryRUCHHeader)
        case .UPS, .UPSDe:
            return tr(.CheckoutDeliveryCourierHeader)
        case .Unknown:
            logError("Unknown carrier type \(id)")
            return ""
        }
    }
}

class CheckoutValidator: Validator {
    @objc var failedMessage: String? = nil
    
    @objc func validate(currentValue: AnyObject?) -> Bool {
        guard let deliveryView = currentValue as? CheckoutDeliveryView else { return false }
        guard let optionViews = deliveryView.addressOptionViews else { return true }
        
        var selected = false
        for optionView in optionViews {
            if optionView.selected {
                selected = true
                break
            }
        }
        return selected
    }
}