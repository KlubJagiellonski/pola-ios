import UIKit

protocol LoginViewDelegate: class {
    func loginViewDidTapFacebook()
    func loginViewDidTapLogin()
    func loginViewDidTapRemindPassword()
    func loginViewDidTapRegister()
}

class LoginView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let facebookButton = UIButton()
    private let orLabel = UILabel()
    private let emailField = FormInputView()
    private let passwordField = FormInputView()
    private let loginButton = UIButton()
    private let remindButton = UIButton()
    private let registerButton = UIButton()
    
    let keyboardHelper = KeyboardHelper()
    var contentValidators: [ContentValidator] = []
    
    weak var delegate: LoginViewDelegate?
    
    init() {
        super.init(frame: CGRectZero)
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        facebookButton.applyFacebookStyle()
        facebookButton.title = tr(.LoginLoginWithFacebook)
        facebookButton.addTarget(self, action: #selector(LoginView.didTapFacebook), forControlEvents: .TouchUpInside)
        
        orLabel.text = tr(.LoginOr)
        orLabel.font = UIFont(fontType: .Normal)
        
        emailField.title = tr(.CommonEmail)
        emailField.inputTextField.tag = 0
        emailField.inputTextField.returnKeyType = .Next
        emailField.inputTextField.keyboardType = .EmailAddress
        emailField.inputTextField.delegate = self
        emailField.addValidator(NotEmptyValidator(messageForEmpty: tr(.ValidatorEmail)))
        
        passwordField.title = tr(.CommonPassword)
        passwordField.inputTextField.secureTextEntry = true
        passwordField.inputTextField.tag = 1
        passwordField.inputTextField.returnKeyType = .Send
        passwordField.inputTextField.delegate = self
        passwordField.addValidator(NotEmptyValidator())
        
        loginButton.applyBlueStyle()
        loginButton.title = tr(.LoginLoginButton)
        loginButton.addTarget(self, action: #selector(LoginView.didTapLogin), forControlEvents: .TouchUpInside)
        
        remindButton.applyPlainStyle()
        remindButton.enabled = false
        remindButton.title = tr(.LoginPassReminder)
        remindButton.addTarget(self, action: #selector(LoginView.didTapRemindPassword), forControlEvents: .TouchUpInside)
        
        registerButton.applyPlainStyle()
        registerButton.title = tr(.LoginNewAccount)
        registerButton.addTarget(self, action: #selector(LoginView.didTapRegister), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(facebookButton)
        contentView.addSubview(orLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(loginButton)
        contentView.addSubview(remindButton)
        contentView.addSubview(registerButton)
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
        
        contentValidators.append(emailField)
        contentValidators.append(passwordField)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginView.dismissKeyboard))
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
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        facebookButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        orLabel.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(facebookButton.snp_bottom).offset(Dimensions.defaultMargin)
        }
        
        emailField.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(orLabel.snp_bottom).offset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        passwordField.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(emailField.snp_bottom)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        loginButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(passwordField.snp_bottom).offset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        remindButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp_bottom).offset(Dimensions.defaultMargin)
        }
        
        registerButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(remindButton.snp_bottom).offset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    @objc private func didTapFacebook() {
        logInfo("Tap login with Facebook")
        delegate?.loginViewDidTapFacebook()
    }
    
    @objc private func didTapLogin() {
        logInfo("Tap login")
        delegate?.loginViewDidTapLogin()
    }
    
    @objc private func didTapRemindPassword() {
        logInfo("Tap remind password")
        delegate?.loginViewDidTapRemindPassword()
    }
    
    @objc private func didTapRegister() {
        logInfo("Tap new account")
        delegate?.loginViewDidTapRegister()
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let formInputView = formInputView(with: textField) {
            formInputView.validate(true)
        }
        return handleTextFieldReturn(textField)
    }
    
    func formInputView(with textField: UITextField) -> FormInputView? {
        if emailField.inputTextField == textField {
            return emailField
        } else if passwordField.inputTextField == textField {
            return passwordField
        }
        return nil
    }
}

extension LoginView: FormView {
    func onFormReachedEnd() {
        dismissKeyboard()
        delegate?.loginViewDidTapLogin()
    }
}

extension LoginView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY)
        let contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}