import UIKit

protocol EditAddressViewDelegate: class {
    func editAddressViewDidTapSaveButton(view: EditAddressView, savedAddressFields: [AddressFormField])
}

class EditAddressView: UIView {
    static let buttonHeight: CGFloat = 52.0
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let saveButton = UIButton()
    private let topSeparator = UIView()
    
    private var formFields: [AddressFormField] {
        set { updateStackView(formFields: newValue) }
        get { return getAddressFields() }
    }
    
    private let keyboardHelper = KeyboardHelper()
    
    weak var delegate: EditAddressViewDelegate?
    
    init(formFields: [AddressFormField]) {
        super.init(frame: CGRectZero)
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        topSeparator.backgroundColor = UIColor(named: .Manatee)
        addSubview(topSeparator)
        
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        stackView.axis = .Vertical
        updateStackView(formFields: formFields)
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
    
    func configureCustomCostraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        scrollView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topSeparator.snp_bottom)
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalTo(scrollView.snp_edges)
            make.width.equalTo(self)
        }
        
        saveButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(scrollView.snp_bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(CheckoutDeliveryView.buttonHeight)
        }
    }
    
    func registerOnKeyboardEvent() {
        keyboardHelper.register()
    }
    
    func unregisterOnKeyboardEvent() {
        keyboardHelper.unregister()
    }
    
    func updateStackView(formFields formFields: [AddressFormField]) {
        for formField in formFields {
            let inputView = CheckoutDeliveryInputView(addressField: formField)
            stackView.addArrangedSubview(inputView)
        }        
    }
        
    func getAddressFields() -> [AddressFormField] {
        var addressFields = [AddressFormField]()
        for view in stackView.arrangedSubviews {
            guard let inputView = view as? CheckoutDeliveryInputView else { break }
            addressFields.append(inputView.addressField)
        }
        return addressFields
    }
    
    func didTapSaveButton() {
        delegate?.editAddressViewDidTapSaveButton(self, savedAddressFields: formFields)
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}

extension EditAddressView: KeyboardHelperDelegate {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY) - saveButton.bounds.height
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
    }
}