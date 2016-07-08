import UIKit

protocol EditAddressViewDelegate: class {
    func editAddressViewDidTapSaveButton(view: EditAddressView)
}

class EditAddressView: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let saveButton = UIButton()
    
    private var formFields: [AddressFormField] {
        set { updateStackView(formFields: newValue) }
        get { return getAddressFields() }
    }
    
    let keyboardHelper = KeyboardHelper()
    var contentValidators: [ContentValidator] = []
    
    weak var delegate: EditAddressViewDelegate?
    var userAddress: UserAddress? {
        return AddressFormField.formFieldsToUserAddress(formFields)
    }
    
    init(userAddress: UserAddress?, defaultCountry: String) {
        super.init(frame: CGRectZero)
        
        let initialFormFields = userAddress != nil ? AddressFormField.createFormFields(with: userAddress!) : AddressFormField.createEmptyFormFields(withDefaultCountry: defaultCountry)
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        stackView.axis = .Vertical
        updateStackView(formFields: initialFormFields)
        scrollView.addSubview(stackView)
        
        saveButton.setTitle(tr(.CheckoutDeliveryEditAddressSave), forState: .Normal)
        saveButton.addTarget(self, action: #selector(EditAddressView.didTapSaveButton), forControlEvents: .TouchUpInside)
        saveButton.applyBlueStyle()
        addSubview(saveButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditAddressView.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomCostraints() {
        scrollView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalTo(scrollView.snp_edges).inset(Dimensions.defaultMargin)
            make.width.equalToSuperview().offset(-2 * Dimensions.defaultMargin)
        }
        
        saveButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(scrollView.snp_bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    private func updateStackView(formFields formFields: [AddressFormField]) {
        for (index, formField) in formFields.enumerate() {
            let inputView = CheckoutDeliveryInputView(addressField: formField)
            inputView.inputTextField.tag = index
            inputView.inputTextField.returnKeyType = index == (formFields.count - 1) ? .Send : .Next
            inputView.inputTextField.keyboardType = formField.keyboardType
            inputView.inputTextField.delegate = self
            contentValidators.append(inputView)
            stackView.addArrangedSubview(inputView)
        }        
    }
        
    private func getAddressFields() -> [AddressFormField] {
        var addressFields = [AddressFormField]()
        for view in stackView.arrangedSubviews {
            guard let inputView = view as? CheckoutDeliveryInputView else { break }
            addressFields.append(inputView.addressField)
        }
        return addressFields
    }
    
    func didTapSaveButton() {
        delegate?.editAddressViewDidTapSaveButton(self)
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}

extension EditAddressView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return handleTextFieldReturn(textField)
    }
}

extension EditAddressView: FormView {
    func onFormReachedEnd() {
        delegate?.editAddressViewDidTapSaveButton(self)
    }
}

extension EditAddressView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY) - saveButton.bounds.height
        scrollView.contentInset = UIEdgeInsetsMake(Dimensions.defaultMargin, 0, max(bottomOffset, 0), 0)
    }
}