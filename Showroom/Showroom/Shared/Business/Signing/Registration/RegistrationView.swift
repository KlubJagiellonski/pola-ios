import UIKit

protocol RegistrationViewDelegate: class {
    func registrationViewDidTapFacebook()
    func registrationViewDidTapRules()
    func registrationViewDidTapCreate()
    func registrationViewDidTapHaveAccount()
    func registrationView(view: RegistrationView, wantShowMessage message: String)
}

class RepeatPasswordValidator: Validator {
    @objc var failedMessage: String?
    
    private var passwordField: FormInputView
    
    @objc func validate(currentValue: AnyObject?) -> Bool {
        failedMessage = nil
        guard let text: String? = currentValue as? String else { fatalError("RepeatPasswordValidator cannot handle different type than String") }
        
        if text != passwordField.inputTextField.text {
            failedMessage = tr(.ValidatorRepeatPassword)
            return false
        }
        
        return true
    }
    
    init(passwordFieldToCompare: FormInputView) {
        self.passwordField = passwordFieldToCompare
    }
}

class RegistrationView: ViewSwitcher {
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private let facebookButton = UIButton()
    private let orLabel = UILabel()
    
    private let repeatPasswordField = FormInputView()
    private let genderSelector = GenderSelectorView()
    private let checksView = UIView()
    private let rulesCheck = CheckButton()
    private let createButton = UIButton()
    private let haveAccountButton = UIButton()
    
    let nameField = FormInputView()
    let emailField = FormInputView()
    let passwordField = FormInputView()
    let newsletterCheck = CheckButton(title: tr(L10n.RegistrationNewsletterCheck))
    
    let keyboardHelper = KeyboardHelper()
    var contentValidators: [ContentValidator] = []
    
    var name: String? {
        return nameField.inputTextField.text
    }
    
    var email: String? {
        return emailField.inputTextField.text
    }
    
    var password: String? {
        return passwordField.inputTextField.text
    }
    
    var gender: Gender {
        return genderSelector.gender
    }
    
    var receiveNewsletter: Bool {
        return newsletterCheck.selected
    }
    
    weak var delegate: RegistrationViewDelegate?
    
    init() {
        super.init(successView: scrollView, initialState: .Success)
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        facebookButton.applyFacebookStyle()
        facebookButton.title = tr(.RegistrationRegisterWithFacebook)
        facebookButton.addTarget(self, action: #selector(RegistrationView.didTapFacebook), forControlEvents: .TouchUpInside)
        
        orLabel.text = tr(.LoginOr)
        orLabel.font = UIFont(fontType: .Normal)
        orLabel.textAlignment = .Center
        
        nameField.title = tr(.RegistrationName)
        nameField.inputTextField.tag = 0
        nameField.inputTextField.returnKeyType = .Next
        nameField.inputTextField.keyboardType = .Default
        nameField.inputTextField.delegate = self
        nameField.addValidator(NotEmptyValidator())
        
        emailField.title = tr(.CommonEmail)
        emailField.inputTextField.tag = 1
        emailField.inputTextField.returnKeyType = .Next
        emailField.inputTextField.keyboardType = .EmailAddress
        emailField.inputTextField.autocapitalizationType = .None
        emailField.inputTextField.delegate = self
        emailField.addValidator(NotEmptyValidator(messageForEmpty: tr(.ValidatorEmail)))
        
        passwordField.title = tr(.CommonPassword)
        passwordField.inputTextField.secureTextEntry = true
        passwordField.inputTextField.tag = 2
        passwordField.inputTextField.returnKeyType = .Next
        passwordField.inputTextField.delegate = self
        passwordField.addValidator(NotEmptyValidator())
        
        repeatPasswordField.title = tr(.RegistrationRepeatPassword)
        repeatPasswordField.inputTextField.secureTextEntry = true
        repeatPasswordField.inputTextField.tag = 3
        repeatPasswordField.inputTextField.returnKeyType = .Next
        repeatPasswordField.inputTextField.delegate = self
        repeatPasswordField.addValidators([RepeatPasswordValidator(passwordFieldToCompare: passwordField), NotEmptyValidator()])
        
        rulesCheck.selected = true
        rulesCheck.title = tr(L10n.RegistrationRulesCheck)
        rulesCheck.link = tr(L10n.RegistrationRulesCheckHighlighted)
        rulesCheck.addTarget(self, action: #selector(RegistrationView.didTapRules), forControlEvents: .TouchUpInside)
        rulesCheck.addValidator(SelectionRequiredValidator(messageForNotSelected: tr(.RegistrationRequiringRulesMessage)))
        rulesCheck.delegate = self
        
        createButton.applyBlueStyle()
        createButton.title = tr(L10n.RegistrationCraeteAccount)
        createButton.addTarget(self, action: #selector(RegistrationView.didTapCreate), forControlEvents: .TouchUpInside)
        
        haveAccountButton.applyPlainStyle()
        haveAccountButton.title = tr(L10n.RegistrationHaveAccount)
        haveAccountButton.addTarget(self, action: #selector(RegistrationView.didTapHaveAccount), forControlEvents: .TouchUpInside)
        
        checksView.addSubview(newsletterCheck)
        checksView.addSubview(rulesCheck)
        
        contentView.axis = .Vertical
        contentView.distribution = .Fill
        
        contentView.addArrangedSubview(facebookButton)
        contentView.addArrangedSubview(orLabel)
        contentView.addArrangedSubview(nameField)
        contentView.addArrangedSubview(emailField)
        contentView.addArrangedSubview(passwordField)
        contentView.addArrangedSubview(repeatPasswordField)
        contentView.addArrangedSubview(genderSelector)
        contentView.addArrangedSubview(checksView)
        contentView.addArrangedSubview(createButton)
        contentView.addArrangedSubview(haveAccountButton)
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
        
        contentValidators.append(nameField)
        contentValidators.append(emailField)
        contentValidators.append(passwordField)
        contentValidators.append(repeatPasswordField)
        contentValidators.append(rulesCheck)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationView.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func configureCustomConstraints() {
        scrollView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalToSuperview().offset(-2 * Dimensions.defaultMargin)
        }
        
        facebookButton.snp_makeConstraints { make in
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        orLabel.snp_makeConstraints { make in
            make.height.equalTo(Dimensions.defaultCellHeight)
        }
        
        createButton.snp_makeConstraints { make in
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        haveAccountButton.snp_makeConstraints { make in
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        newsletterCheck.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview()
        }
        
        rulesCheck.snp_makeConstraints { make in
            make.top.equalTo(newsletterCheck.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    @objc private func didTapFacebook() {
        logInfo("Tap login with Facebook")
        delegate?.registrationViewDidTapFacebook()
    }
    
    @objc private func didTapRules() {
        logInfo("Tap rules")
        delegate?.registrationViewDidTapRules()
    }
    
    @objc private func didTapCreate() {
        logInfo("Tap create account")
        delegate?.registrationViewDidTapCreate()
    }
    
    @objc private func didTapHaveAccount() {
        logInfo("Tap have an account?")
        delegate?.registrationViewDidTapHaveAccount()
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return handleTextFieldReturn(textField)
    }
}

extension RegistrationView: FormView {
    func onFormReachedEnd() {
        dismissKeyboard()
        delegate?.registrationViewDidTapCreate()
    }
}

extension RegistrationView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions, visible: Bool) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY)
        let contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

extension RegistrationView: CheckButtonDelegate {
    func checkButton(checkButton: CheckButton, wantsShowMessage message: String) {
        delegate?.registrationView(self, wantShowMessage: message)
    }
}

class GenderSelectorView: UIControl {
    private let titleLabel = UILabel()
    private let femaleButton = RadioButton(title: tr(L10n.RegistrationFemale))
    private let maleButton = RadioButton(title: tr(L10n.RegistrationMale))
    
    var gender: Gender {
        get {
            return femaleButton.selected ? .Female : .Male
        }
        
        set {
            switch newValue {
            case .Female:
                femaleButton.selected = true
                maleButton.selected = false
            case .Male:
                femaleButton.selected = false
                maleButton.selected = true
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        titleLabel.text = tr(L10n.RegistrationGender)
        titleLabel.font = UIFont(fontType: .FormBold)
        
        femaleButton.addTarget(self, action: #selector(GenderSelectorView.didChangeFemaleValue), forControlEvents: .ValueChanged)
        femaleButton.selected = true
        maleButton.addTarget(self, action: #selector(GenderSelectorView.didChangeMaleValue), forControlEvents: .ValueChanged)
        
        addSubview(titleLabel)
        addSubview(femaleButton)
        addSubview(maleButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        femaleButton.snp_makeConstraints { make in
            make.left.equalToSuperview().offset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        maleButton.snp_makeConstraints { make in
            make.left.equalTo(self.snp_centerX).offset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, Dimensions.defaultCellHeight * 2)
    }
    
    func didChangeFemaleValue() {
        femaleButton.selected = true
        maleButton.selected = false
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func didChangeMaleValue() {
        femaleButton.selected = false
        maleButton.selected = true
        sendActionsForControlEvents(.ValueChanged)
    }
}
