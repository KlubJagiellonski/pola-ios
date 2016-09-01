import UIKit
import RxSwift

typealias Address = String

extension AddressFormField: CustomStringConvertible {
    private var value: String? {
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
    
    private var validators: [Validator] {
        var validators: [Validator] = []
        if case Country = self {
        } else {
            validators.append(NotEmptyValidator())
        }
        return validators
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
        case .FirstName: return .FirstName(value: inputTextField.notEmptyText)
        case .LastName: return .LastName(value: inputTextField.notEmptyText)
        case .StreetAndApartmentNumbers: return .StreetAndApartmentNumbers(value: inputTextField.notEmptyText)
        case .PostalCode: return .PostalCode(value: inputTextField.notEmptyText)
        case .City: return .City(value: inputTextField.notEmptyText)
        case .Country: return .Country(defaultValue: inputTextField.placeholder!)
        case .Phone: return .Phone(value: inputTextField.notEmptyText)
        }
    }
    
    private func updateTextField(addressFormField addressFormField: AddressFormField) {
        addValidators(addressFormField.validators)
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

final class CheckoutDeliveryLabelView: UIView {
    static let labelHeight: CGFloat = 17.0
    static let inset: CGFloat = 10.0
    
    let label = UILabel()
    
    init(text: String, topMargin: CGFloat) {
        super.init(frame: CGRectZero)
        
        label.backgroundColor = UIColor(named: .White)
        label.text = text
        label.font = UIFont(fontType: .FormBold)
        addSubview(label)
        configureCustomConstraints(topMargin: topMargin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints(topMargin topMargin: CGFloat) {
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(topMargin)
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

enum CheckoutDeliveryEditingState {
    case Edit
    case Add
    
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
    let chooseKioskButton = UIButton()
    let changeKioskButton = UIButton()
    
    private let disposeBag = DisposeBag()
    private let initialText: String
    
    init(checkoutState: CheckoutState) {
        initialText = checkoutState.checkout.deliveryCarrier.name
        super.init(frame: CGRectZero)
        
        updateData(with: checkoutState.checkout)
        checkoutState.selectedKioskObservable.subscribeNext { [weak self] kiosk in
            self?.updateData(kiosk)
            }.addDisposableTo(disposeBag)
        
        label.backgroundColor = UIColor(named: .White)
        label.font = UIFont(fontType: .FormNormal)
        label.numberOfLines = 3
        label.lineBreakMode = .ByWordWrapping
        
        chooseKioskButton.applyPlainStyle()
        chooseKioskButton.title = tr(.CheckoutDeliveryDeliveryRUCHPickKiosk)
        chooseKioskButton.addTarget(self, action: #selector(CheckoutDeliveryDetailsView.didTapChooseButton(_:)), forControlEvents: .TouchUpInside)
        
        changeKioskButton.applyPlainStyle()
        changeKioskButton.title = tr(.CheckoutDeliveryDeliveryRUCHChangeKiosk)
        changeKioskButton.addTarget(self, action: #selector(CheckoutDeliveryDetailsView.didTapChangeButton(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(label)
        addSubview(chooseKioskButton)
        addSubview(changeKioskButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateData(with checkout: Checkout) {
        switch checkout.deliveryCarrier.id {
        case .UPS, .UPSDe:
            label.text = "\(checkout.deliveryCountry.name), \(checkout.deliveryCarrier.name)"
            chooseKioskButton.hidden = true
            changeKioskButton.hidden = true
        case .RUCH:
            label.text = initialText
            chooseKioskButton.hidden = false
            changeKioskButton.hidden = true
        case .Unknown:
            logError("Unknown carrier type when updating data: \(checkout.deliveryCarrier.id)")
        }
    }
    
    private func updateData(kiosk: Kiosk?) {
        if let kiosk = kiosk {
            let address = "\(kiosk.city), \(kiosk.street)"
            label.text = "\(initialText)\n\(address)"
            chooseKioskButton.hidden = true
            changeKioskButton.hidden = false
        } else {
            label.text = initialText
            chooseKioskButton.hidden = false
            changeKioskButton.hidden = true
        }
    }
    
    func didTapChooseButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapChooseKioskButton()
    }
    
    func didTapChangeButton(sender: UIButton) {
        deliveryView?.dataSourceDidTapChangeKioskButton()
    }
    
    private func configureCustomConstraints() {
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(chooseKioskButton.snp_leading)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        chooseKioskButton.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        chooseKioskButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.baseline.equalTo(label)
        }
        
        changeKioskButton.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        changeKioskButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.baseline.equalTo(label)
        }
    }
}
