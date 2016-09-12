import UIKit

protocol ResetPasswordViewDelegate: class {
    func resetPasswordViewDidReset()
}

class ResetPasswordView: ViewSwitcher {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = UILabel()
    private let resetButton = UIButton()
    
    let emailField = FormInputView()
    
    let keyboardHelper = KeyboardHelper()
    var contentValidators: [ContentValidator] = []
    
    var email: String? {
        return emailField.inputTextField.text
    }
    
    weak var delegate: ResetPasswordViewDelegate?
    
    init() {
        super.init(successView: scrollView, initialState: .Success)
        
        switcherDataSource = self
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        descriptionLabel.backgroundColor = UIColor(named: .White)
        descriptionLabel.text = tr(L10n.ResetPasswordEmailDescription)
        descriptionLabel.font = UIFont(fontType: .Normal)
        descriptionLabel.numberOfLines = 0
        
        emailField.title = tr(.CommonEmail)
        emailField.inputTextField.tag = 0
        emailField.inputTextField.returnKeyType = .Next
        emailField.inputTextField.keyboardType = .EmailAddress
        emailField.inputTextField.autocapitalizationType = .None
        emailField.inputTextField.delegate = self
        emailField.addValidator(NotEmptyValidator(messageForEmpty: tr(.ValidatorEmail)))
        
        resetButton.applyBlueStyle()
        resetButton.title = tr(L10n.ResetPasswordReset)
        resetButton.addTarget(self, action: #selector(ResetPasswordView.didTapReset), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(resetButton)
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
        
        contentValidators.append(emailField)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordView.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.defaultMargin * 2)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        emailField.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(Dimensions.defaultMargin * 4)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        resetButton.snp_makeConstraints { make in
            make.top.equalTo(emailField.snp_bottom).offset(8)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    @objc private func didTapReset() {
        delegate?.resetPasswordViewDidReset()
    }
}

extension ResetPasswordView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return handleTextFieldReturn(textField)
    }
}

extension ResetPasswordView: FormView {
    func onFormReachedEnd() {
        dismissKeyboard()
        delegate?.resetPasswordViewDidReset()
    }
}

extension ResetPasswordView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return ResetPasswordSuccessView()
    }
}

extension ResetPasswordView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions, visible: Bool) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY)
        let contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

class ResetPasswordSuccessView: UIView {
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        
        imageView.image = UIImage(asset: Asset.Img_password)
        
        descriptionLabel.text = tr(L10n.ResetPasswordSuccessDescription)
        descriptionLabel.font = UIFont(fontType: .Normal)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .Center
        
        addSubview(imageView)
        addSubview(descriptionLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        imageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.centerY.equalToSuperview()
            make.top.equalTo(imageView.snp_bottom).offset(Dimensions.defaultMargin * 2)
        }
    }
}