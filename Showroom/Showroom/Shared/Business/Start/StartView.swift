import UIKit

protocol StartViewDelegate: class {
    func startViewDidTapLogin()
    func startViewDidTapRegister()
    func startViewDidTapForHer()
    func startViewDidTapForHim()
}

class StartView: UIView {
    private let logo = UIImageView()
    private let forHerButton = StartButton()
    private let forHimButton = StartButton()
    private let loginButton = UIButton()
    private let registerButton = UIButton()
    
    weak var delegate: StartViewDelegate?
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        logo.image = UIImage(asset: Asset.Profile_logo)
        
        forHerButton.startImageView.image = UIImage(asset: Asset.For_her)
        forHerButton.targetLabel.text = tr(L10n.StartForHer)
        forHerButton.addTarget(self, action: #selector(StartView.didTapForHer), forControlEvents: .TouchUpInside)
        
        forHimButton.startImageView.image = UIImage(asset: Asset.For_him)
        forHimButton.targetLabel.text = tr(L10n.StartForHim)
        forHimButton.addTarget(self, action: #selector(StartView.didTapForHim), forControlEvents: .TouchUpInside)
        
        loginButton.title = tr(L10n.StartLogin)
        loginButton.applyGhostStyle()
        loginButton.addTarget(self, action: #selector(StartView.didTapLogin), forControlEvents: .TouchUpInside)
        
        registerButton.title = tr(L10n.StartRegister)
        registerButton.applyGhostStyle()
        registerButton.addTarget(self, action: #selector(StartView.didTapRegister), forControlEvents: .TouchUpInside)
        
        addSubview(logo)
        addSubview(forHerButton)
        addSubview(forHimButton)
        addSubview(loginButton)
        addSubview(registerButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        logo.snp_makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(67)
            make.top.equalToSuperview().offset(42)
            make.centerX.equalToSuperview()
        }
        
        forHerButton.snp_makeConstraints { make in
            make.top.equalTo(logo.snp_bottom).offset(34)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        forHimButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(forHerButton.snp_bottom).offset(Dimensions.defaultMargin)
            make.bottom.equalTo(loginButton.snp_top).offset(-Dimensions.defaultMargin)
            make.height.equalTo(forHerButton)
        }
        
        loginButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalTo(self.snp_centerX).offset(-5)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultCellHeight)
        }
        
        registerButton.snp_makeConstraints { make in
            make.left.equalTo(self.snp_centerX).offset(5)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultCellHeight)
        }
    }
    
    @objc private func didTapForHer() {
        delegate?.startViewDidTapForHer()
    }
    
    @objc private func didTapForHim() {
        delegate?.startViewDidTapForHim()
    }
    
    @objc private func didTapLogin() {
        delegate?.startViewDidTapLogin()
    }
    
    @objc private func didTapRegister() {
        delegate?.startViewDidTapRegister()
    }
}

class StartButton: UIButton {
    private let containerView = UIView()
    
    let startImageView = UIImageView()
    private let browseLabel = UILabel()
    let targetLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        
        setBackgroundImage(UIImage.fromColor(UIColor(named: .White)), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: ColorName.Gray)), forState: .Highlighted)
        layer.borderColor = UIColor(named: .Blue).CGColor
        layer.borderWidth = 2
        
        startImageView.contentMode = .ScaleAspectFit
        
        browseLabel.text = tr(L10n.StartBrowse)
        browseLabel.font = UIFont.georgiaItalic(ofSize: 14)
        
        targetLabel.font = UIFont.latoBold(ofSize: 24)
        
        containerView.addSubview(startImageView)
        containerView.addSubview(browseLabel)
        containerView.addSubview(targetLabel)
        
        addSubview(containerView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        containerView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        startImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        browseLabel.snp_makeConstraints { make in
            make.bottom.equalTo(containerView.snp_centerY).offset(-2)
            make.leading.equalToSuperview().offset(90)
            make.trailing.equalToSuperview()
        }
        
        targetLabel.snp_makeConstraints { make in
            make.top.equalTo(self.snp_centerY).offset(-2)
            make.leading.equalTo(browseLabel)
            make.trailing.equalToSuperview()
        }
    }
}