import UIKit

typealias Address = String

enum AddressInput {
    case Options(addresses: [[AddressFormField]])
    case Form(fields: [AddressFormField])
}

enum AddressFormField: CustomStringConvertible {
    case FirstName(value: String?)
    case LastName(value: String?)
    case StreetAndApartmentNumbers(value: String?)
    case PostalCode(value: String?)
    case City(value: String?)
    case Country(defaultValue: String)
    case Phone(value: String?)
    
    var value: String? {
        switch self {
            case FirstName(let value): return value
            case LastName(let value): return value
            case StreetAndApartmentNumbers(let value): return value
            case PostalCode(let value): return value
            case City(let value): return value
            case Country(let value): return value
            case Phone(let value): return value
        }
    }
    
    var description: String {
        switch self {
        case FirstName: return tr(.CheckoutDeliveryAddressFormFirstName)
        case LastName: return tr(.CheckoutDeliveryAddressFormLastName)
        case StreetAndApartmentNumbers: return tr(.CheckoutDeliveryAddressFormStreetAndApartmentNumbers)
        case PostalCode: return tr(.CheckoutDeliveryAddressFormPostalCode)
        case City: return tr(.CheckoutDeliveryAddressFormCity)
        case Country: return tr(.CheckoutDeliveryAddressFormCountry)
        case Phone: return tr(.CheckoutDeliveryAddressFormPhone)
        }
    }
    
    var validators: [Validator] {
        var validators: [Validator] = []
        if case Phone = self {
            validators.append(PhoneNumberValidator())
            validators.append(NotEmptyValidator())
        } else if case Country = self {
        } else {
            validators.append(NotEmptyValidator())
        }
        return validators
    }
    
    var placeholder: String? {
        switch self {
        case Phone:
            return "+48"
        default:
            return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case PostalCode:
            return .NumbersAndPunctuation
        case Phone:
            return .PhonePad
        default:
            return .Default
        }
    }
}

enum Delivery {
    case Courier
    case Kiosk(address: String?)
    
    var headerText: String {
        switch self {
        case .Courier: return tr(.CheckoutDeliveryCourierHeader)
        case .Kiosk: return tr(.CheckoutDeliveryRUCHHeader)
        }
    }
}

class CheckoutDeliveryInfoHeaderView: UIView {
    let label = UILabel()

    init(delivery: Delivery) {
        super.init(frame: CGRectZero)
        label.font = UIFont(fontType: .Description)
        label.numberOfLines = 2
        label.lineBreakMode = .ByWordWrapping
        label.text = delivery.headerText

        addSubview(label)
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, label.intrinsicContentSize().height + 2 * Dimensions.defaultMargin)
    }
}

class CheckoutDeliveryInputView: FormInputView {
    private let inputType: AddressFormField
    private(set) var addressField: AddressFormField {
        get { return getAddressField() }
        set { updateTextField(addressFormField: newValue) }
    }
    
    init(addressField: AddressFormField) {
        self.inputType = addressField
        super.init()
        updateTextField(addressFormField: addressField)
        updateInputType(self.inputType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAddressField() -> AddressFormField {
        switch inputType {
        case .FirstName: return .FirstName(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        case .LastName: return .LastName(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        case .StreetAndApartmentNumbers: return .StreetAndApartmentNumbers(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        case .PostalCode: return .PostalCode(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        case .City: return .City(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        case .Country: return .Country(defaultValue: inputTextField.placeholder!)
        case .Phone: return .Phone(value: inputTextField.text!.isEmpty ? nil : inputTextField.text!)
        }
    }
    
    private func updateTextField(addressFormField addressFormField: AddressFormField) {
        addValidators(addressFormField.validators)
        inputTextField.placeholder = addressFormField.placeholder
        switch addressFormField {
        case .FirstName(let value): inputTextField.text = value
        case .LastName(let value): inputTextField.text = value
        case .StreetAndApartmentNumbers(let value): inputTextField.text = value
        case .PostalCode(let value): inputTextField.text = value
        case .City(let value): inputTextField.text = value
        case .Country(let defaultValue):
            inputTextField.enabled = false
            inputTextField.placeholder = defaultValue
        case .Phone(let value): inputTextField.text = value
        }
    }
    
    func updateInputType(toInputType: AddressFormField) {
        title = String(toInputType)
    }
}

class CheckoutDeliveryLabelView: UIView {
    static let labelHeight: CGFloat = 17.0
    static let inset: CGFloat = 10.0
    
    let label = UILabel()
    
    init(text: String) {
        super.init(frame: CGRectZero)
        label.text = text
        label.font = UIFont(fontType: .FormBold)
        addSubview(label)
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(CheckoutDeliveryLabelView.labelHeight)
            make.bottom.equalToSuperview().inset(CheckoutDeliveryLabelView.inset)
        }
    }
}

class CheckoutDeliveryAddressOptionView: UIView {
    static let buttonHeight: CGFloat = 51.0
    static let inset: CGFloat = 21.0
    
    let addressOption: CheckoutAddressOptionView
    
    weak var deliveryView: CheckoutDeliveryView?
    
    var selected: Bool {
        set { addressOption.selected = newValue }
        get { return addressOption.selected }
    }
    
    init(address: Address, selected: Bool) {
        addressOption = CheckoutAddressOptionView(title: address, selected: selected)
        super.init(frame: CGRectZero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CheckoutDeliveryAddressOptionView.didTap))
        addGestureRecognizer(tap)
        
        addSubview(addressOption)
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        addressOption.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(CheckoutDeliveryAddressOptionView.inset)
        }
    }
    
    func didTap() {
        deliveryView?.didTapAddressOptionView(self)
    }
}

extension CheckoutDeliveryEditingState {
    private var buttonTitle: String {
        switch self {
        case Edit: return tr(.CheckoutDeliveryAdressEdit)
        case Add: return tr(.CheckoutDeliveryAdressAdd)
        }
    }
}
class CheckoutDeliveryEditButtonView: UIView {
    static let labelHeight: CGFloat = 16.0
    static let inset: CGFloat = 33.0
    
    weak var deliveryView: CheckoutDeliveryView?
    
    let button = UIButton()
    
    init(editingType: CheckoutDeliveryEditingState) {
        super.init(frame: CGRectZero)
        button.applyPlainStyle()
        button.setTitle(editingType.buttonTitle, forState: .Normal)
        
        switch editingType {
        case .Add:
            button.addTarget(self, action: #selector(CheckoutDeliveryEditButtonView.didTapAddButton(_:)), forControlEvents: .TouchUpInside)
        case .Edit:
            button.addTarget(self, action: #selector(CheckoutDeliveryEditButtonView.didTapChangeButton(_:)), forControlEvents: .TouchUpInside)
        }
        
        addSubview(button)
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAddButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapAddAddressButton()
    }
    
    func didTapChangeButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapEditAddressButton()
    }

    func configureCustomConstraints() {
        button.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(CheckoutDeliveryEditButtonView.labelHeight)
            make.bottom.equalToSuperview().inset(CheckoutDeliveryEditButtonView.inset)
        }
    }
}

class CheckoutDeliveryDetailsView: UIView {
    static let labelHeight: CGFloat = 34.0
    static let labelWidth: CGFloat = 181.0
    static let inset: CGFloat = 22.0
    
    weak var deliveryView: CheckoutDeliveryView?
    
    let label = UILabel()
    let button = UIButton()
    
    init(delivery: Delivery) {
        super.init(frame: CGRectZero)
        
        updateDeliveryTo(delivery)
        
        label.font = UIFont(fontType: .FormNormal)
        label.numberOfLines = 3
        label.lineBreakMode = .ByWordWrapping
        
        button.applyPlainStyle()
        
        addSubview(label)
        addSubview(button)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDeliveryTo(toDelivery: Delivery) {
        switch toDelivery {
        case .Courier:
            label.text = tr(.CheckoutDeliveryDeliveryCourier)
            button.hidden = true
        case .Kiosk(let address):
            if let address = address {
                label.text = tr(.CheckoutDeliveryDeliveryRUCH) + "\n" + address
                button.setTitle(tr(.CheckoutDeliveryDeliveryRUCHChangeKiosk), forState: .Normal)
                button.addTarget(self, action: #selector(CheckoutDeliveryDetailsView.didTapChangeButton(_:)), forControlEvents: .TouchUpInside)
                button.hidden = false
            } else {
                label.text = tr(.CheckoutDeliveryDeliveryRUCH)
                button.setTitle(tr(.CheckoutDeliveryDeliveryRUCHPickKiosk), forState: .Normal)
                button.addTarget(self, action: #selector(CheckoutDeliveryDetailsView.didTapChooseButton(_:)), forControlEvents: .TouchUpInside)
                button.hidden = false
            }
        }
    }
    
    func didTapChooseButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapChooseKioskButton()
    }
    
    func didTapChangeButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapChangeKioskButton()
    }
    
    func configureCustomConstraints() {
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.lessThanOrEqualTo(button.snp_leading)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        button.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}