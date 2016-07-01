import UIKit

protocol LoginViewDelegate: class {
    func loginViewDidTapFacebook()
    func loginViewDidTapLogin()
    func loginViewDidTapRemindPassword()
    func loginViewDidTapRegister()
}

class LoginView: UIView {
    private let facebookButton = UIButton()
    private let orLabel = UILabel()
    private let emailField = FormInputView()
    private let passwordField = FormInputView()
    private let loginButton = UIButton()
    private let remindButton = UIButton()
    private let registerButton = UIButton()
    
    weak var delegate: LoginViewDelegate?
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor(named: .White)
        
        facebookButton.applyFacebookStyle()
        facebookButton.title = tr(.LoginLoginWithFacebook)
        facebookButton.addTarget(self, action: #selector(LoginView.didTapFacebook), forControlEvents: .TouchUpInside)
        
        orLabel.text = tr(.LoginOr)
        orLabel.font = UIFont(fontType: .Normal)
        
        emailField.title = tr(.LoginEmail)
        
        passwordField.title = tr(.LoginPassword)
        passwordField.inputTextField.secureTextEntry = true
        
        loginButton.applyBlueStyle()
        loginButton.title = tr(.LoginLoginButton)
        loginButton.enabled = false
        loginButton.addTarget(self, action: #selector(LoginView.didTapLogin), forControlEvents: .TouchUpInside)
        
        remindButton.applyPlainStyle()
        remindButton.enabled = false
        remindButton.title = tr(.LoginPassReminder)
        remindButton.addTarget(self, action: #selector(LoginView.didTapRemindPassword), forControlEvents: .TouchUpInside)
        
        registerButton.applyPlainStyle()
        registerButton.title = tr(.LoginNewAccount)
        registerButton.addTarget(self, action: #selector(LoginView.didTapRegister), forControlEvents: .TouchUpInside)
        
        addSubview(facebookButton)
        addSubview(orLabel)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(remindButton)
        addSubview(registerButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
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
