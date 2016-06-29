import UIKit

protocol KioskSearchInputFieldDelegate: class {
    func kioskSearchInputDidReturn(view: KioskSearchInputField, searchString: String)
}

class KioskSearchInputField: UIView {
    static let inputLabelToTopInset: CGFloat = 17.0
    static let inputLabelHeight: CGFloat = 17.0
    static let inputLabelToTextFieldOffset: CGFloat = 10.0
    static let textFieldHeight: CGFloat = 41.0
    static let errorLabelHeight: CGFloat = 24.0
    static let errorLabelToBottomInset: CGFloat = 1.0
    
    private let inputLabel = UILabel()
    private let inputTextField = FormInputTextField(frame: CGRectZero)
    private let errorLabel = FormFieldValidationLabel(frame: CGRectZero)
    
    weak var delegate: KioskSearchInputFieldDelegate?
    
    var searchString: String {
        get { return inputTextField.text! }
        set { inputTextField.text = newValue }
    }
    
    var errorString: String? {
        didSet {
            if let errorString = errorString {
                errorLabel.text = errorString
                errorLabel.hidden = false
            } else {
                errorLabel.hidden = true
                errorLabel.text = ""
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        inputLabel.text = tr(.CheckoutDeliveryEditKioskSearchInputLabel)
        inputLabel.font = UIFont(fontType: .FormBold)
        
        inputTextField.placeholder = tr(.CheckoutDeliveryEditKioskSearchInputPlaceholder)
        inputTextField.addTarget(self, action: #selector(KioskSearchInputField.onTextFieldReturn), forControlEvents: .EditingDidEnd)
        inputTextField.addTarget(self, action: #selector(KioskSearchInputField.onTextFieldReturn), forControlEvents: .EditingDidEndOnExit)
        inputTextField.returnKeyType = .Search
        
        errorLabel.hidden = true
        
        addSubview(inputLabel)
        addSubview(inputTextField)
        addSubview(errorLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onTextFieldReturn() {
        delegate?.kioskSearchInputDidReturn(self, searchString: searchString)
    }
    
    func configureCustomConstraints() {
        inputLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview().inset(KioskSearchInputField.inputLabelToTopInset)
            make.height.equalTo(KioskSearchInputField.inputLabelHeight)
        }
        
        inputTextField.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(inputLabel.snp_bottom).offset(KioskSearchInputField.inputLabelToTextFieldOffset)
            make.height.equalTo(KioskSearchInputField.textFieldHeight)
        }
        
        errorLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(inputTextField.snp_bottom)
            make.height.equalTo(KioskSearchInputField.errorLabelHeight)
            make.bottom.equalToSuperview().inset(KioskSearchInputField.errorLabelToBottomInset)
        }

        
        
        
    }
}