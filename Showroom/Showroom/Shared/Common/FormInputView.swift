import UIKit
import SnapKit

extension FormInputView: ContentValidator {
    func getValue() -> AnyObject? {
        return inputTextField.text
    }
    
    func showError(error: String) {
        validationLabel.text = error
        validationLabel.hidden = false
    }
    
    func hideError() {
        validationLabel.hidden = true
    }
}

class FormInputView: UIView {
    static let inputLabelHeight: CGFloat = 17.0
    static let inputLabelToTextFieldOffset: CGFloat = 10.0
    static let validationLabelHeight: CGFloat = 25.0
    static let validationLabelToBottomInset: CGFloat = 8.0
    
    private let inputLabel = UILabel()
    let inputTextField = FormInputTextField(frame: CGRectZero)
    private let validationLabel = ExtendedLabel(frame: CGRectZero)
    private var bottomConstraint: Constraint?
    
    var title: String? {
        get {
            return inputLabel.text
        }
        set {
            inputLabel.text = newValue
        }
    }
    
    var validation: String? {
        get {
            return validationLabel.text
        }
        set {
            validationLabel.text = newValue
            validationLabel.hidden = newValue == nil
        }
    }
    
    var bottomOffsetEnabled = true {
        didSet {
            bottomConstraint?.updateOffset(bottomOffsetEnabled ? -FormInputView.validationLabelToBottomInset : 0)
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        inputLabel.backgroundColor = UIColor(named: .White)
        inputLabel.font = UIFont(fontType: .FormBold)
        
        validationLabel.applyFormValidationStyle()
        validationLabel.hidden = true
        
        addSubview(inputLabel)
        addSubview(inputTextField)
        addSubview(validationLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCustomConstraints() {
        inputLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        inputTextField.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(inputLabel.snp_bottom).offset(FormInputView.inputLabelToTextFieldOffset)
        }
        
        validationLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(inputTextField.snp_bottom)
            make.height.equalTo(FormInputView.validationLabelHeight)
            bottomConstraint = make.bottom.equalToSuperview().offset(-FormInputView.validationLabelToBottomInset).constraint
        }
    }
}
