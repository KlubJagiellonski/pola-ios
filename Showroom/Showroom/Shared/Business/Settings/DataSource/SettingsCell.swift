import UIKit

class SettingsHeaderCell: UITableViewCell {
    static let clothesImageTopInset: CGFloat = 15.0
    private static let socialMediaButtonCenterXOffset: CGFloat = 24.0
    private static let socialMediaButtonTopOffset: CGFloat = 21.0
    
    private let clothesImageView = UIImageView(image: UIImage(asset: .Profile_header))
    private let logoImageView = UIImageView(image: UIImage(asset: .Profile_logo))
    private let facebookButton = UIButton()
    private let instagramButton = UIButton()
    private let separatorView = UIView()
    
    var facebookAction: (() -> ())?
    var instagramAction: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        facebookButton.setImage(UIImage(asset: .Ic_facebook), forState: .Normal)
        instagramButton.setImage(UIImage(asset: .Ic_instagram), forState: .Normal)

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        facebookButton.addTarget(self, action: #selector(SettingsHeaderCell.didTapFacebookButton), forControlEvents: .TouchUpInside)
        instagramButton.addTarget(self, action: #selector(SettingsHeaderCell.didTapInstagramButton), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(clothesImageView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(facebookButton)
        contentView.addSubview(instagramButton)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapFacebookButton() {
        facebookAction?()
    }
    
    func didTapInstagramButton() {
        instagramAction?()
    }
    
    private func configureCustomConstraints() {
        clothesImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(SettingsHeaderCell.clothesImageTopInset)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        facebookButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview().offset(-SettingsHeaderCell.socialMediaButtonCenterXOffset)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        instagramButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview().offset(SettingsHeaderCell.socialMediaButtonCenterXOffset)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }

}

class SettingsLoginCell: UITableViewCell {
    private let loginButton = UIButton()
    private let createAccountButton = UIButton()
    private let verticalSeparator = UIView()
    private let horizontalSeparator = UIView()
    
    var loginAction: (() -> ())?
    var createAccountAction: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        loginButton.title = tr(.SettingsLogin)
        loginButton.applyLoginStyle()
        loginButton.addTarget(self, action: #selector(SettingsLoginCell.didTapLoginButton), forControlEvents: .TouchUpInside)
        
        createAccountButton.title = tr(.SettingsCreateAccount)
        createAccountButton.applyLoginStyle()
        createAccountButton.addTarget(self, action: #selector(SettingsLoginCell.didTapCreateAccountButton), forControlEvents: .TouchUpInside)

        
        verticalSeparator.backgroundColor = UIColor(named: .Separator)
        horizontalSeparator.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(loginButton)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(verticalSeparator)
        contentView.addSubview(horizontalSeparator)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapLoginButton() {
        loginAction?()
    }
    
    func didTapCreateAccountButton() {
        createAccountAction?()
    }
    
    private func createCustomConstraints() {
        loginButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(verticalSeparator.snp_leading)
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        verticalSeparator.snp_makeConstraints { make in
            make.trailing.equalTo(createAccountButton.snp_leading)
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
            make.width.equalTo(Dimensions.defaultSeparatorThickness)
            make.centerX.equalToSuperview()
        }
        
        createAccountButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        horizontalSeparator.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
    
}

class SettingsLogoutCell: UITableViewCell {
    private let label = UILabel()
    private let logoutButton = UIButton()
    private let horizontalSeparator = UIView()
    
    var logoutAction: (() -> ())?
    
    var labelText: String? {
        set { label.text = newValue }
        get { return label.text! }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        label.font = UIFont(fontType: .Normal)
        
        logoutButton.title = tr(.SettingsLogout)
        logoutButton.applyLoginStyle()
        logoutButton.addTarget(self, action: #selector(SettingsLogoutCell.didTapLodoutButton), forControlEvents: .TouchUpInside)
        
        horizontalSeparator.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(label)
        contentView.addSubview(logoutButton)
        addSubview(horizontalSeparator)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapLodoutButton() {
        logoutAction?()
    }
    
    private func createCustomConstraints() {
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.lessThanOrEqualTo(logoutButton.snp_leading).offset(-Dimensions.defaultMargin)
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        logoutButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        horizontalSeparator.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
}

class SettingsGenderCell: UITableViewCell {
    private static let genderButtonVerticalInset: CGFloat = 6.0
    private static let genderButtonWidth: CGFloat = 59.0
    
    private let label = UILabel()
    private let femaleButton = UIButton()
    private let maleButton = UIButton()
    private let horizontalSeparator = UIView()
    
    var selectedGender: Gender? {
        didSet {
            if let gender = selectedGender {
                updateGender(gender)
            }
        }
    }
    
    var femaleAction: (() -> ())?
    var maleAction: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        label.text = tr(.SettingsDefaultOffer)
        label.font = UIFont(fontType: .Normal)
        
        femaleButton.title = tr(.SettingsFemale)
        femaleButton.layer.borderColor = UIColor(named: .Black).CGColor
        femaleButton.layer.borderWidth = 1.0
        femaleButton.addTarget(self, action: #selector(SettingsGenderCell.didTapFemaleButton), forControlEvents: .TouchUpInside)
        
        maleButton.title = tr(.SettingsMale)
        maleButton.layer.borderColor = UIColor(named: .Black).CGColor
        maleButton.layer.borderWidth = 1.0
        maleButton.addTarget(self, action: #selector(SettingsGenderCell.didTapMaleButton), forControlEvents: .TouchUpInside)
        
        horizontalSeparator.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(label)
        contentView.addSubview(femaleButton)
        contentView.addSubview(maleButton)
        contentView.addSubview(horizontalSeparator)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateGender(selectedGender: Gender) {
        switch selectedGender {
        case .Male:
            femaleButton.backgroundColor = UIColor(named: .White)
            femaleButton.setTitleColor(UIColor(named: .Black), forState: .Normal)
            maleButton.backgroundColor = UIColor(named: .Black)
            maleButton.setTitleColor(UIColor(named: .White), forState: .Normal)
        case .Female:
            femaleButton.backgroundColor = UIColor(named: .Black)
            femaleButton.setTitleColor(UIColor(named: .White), forState: .Normal)
            maleButton.backgroundColor = UIColor(named: .White)
            maleButton.setTitleColor(UIColor(named: .Black), forState: .Normal)
        }
    }
    
    func didTapFemaleButton() {
        selectedGender = .Female
        femaleAction?()
    }
    
    func didTapMaleButton() {
        selectedGender = .Male
        maleAction?()
    }
    
    private func createCustomConstraints() {
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.lessThanOrEqualTo(femaleButton.snp_leading).offset(-Dimensions.defaultMargin)
            make.top.equalToSuperview()
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        femaleButton.snp_makeConstraints { make in
            make.trailing.equalTo(maleButton.snp_leading)
            make.top.equalToSuperview().inset(SettingsGenderCell.genderButtonVerticalInset)
            make.bottom.equalTo(horizontalSeparator.snp_top).offset(-SettingsGenderCell.genderButtonVerticalInset)
            make.width.equalTo(SettingsGenderCell.genderButtonWidth)
        }
        
        maleButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview().inset(SettingsGenderCell.genderButtonVerticalInset)
            make.bottom.equalTo(horizontalSeparator.snp_top).offset(-SettingsGenderCell.genderButtonVerticalInset)
            make.width.equalTo(SettingsGenderCell.genderButtonWidth)
        }
        
        horizontalSeparator.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
}

class SettingsNormalCell: UITableViewCell {
    private let label = UILabel()
    private let chevron = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    private let horizontalSeparator = UIView()
    
    var labelText: String? {
        set { label.text = newValue }
        get { return label.text! }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        label.font = UIFont(fontType: .Normal)
        
        horizontalSeparator.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(label)
        contentView.addSubview(chevron)
        addSubview(horizontalSeparator)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCustomConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.lessThanOrEqualTo(chevron.snp_leading).offset(Dimensions.defaultMargin)
            make.bottom.equalTo(horizontalSeparator.snp_top)
        }
        
        chevron.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.centerY.equalToSuperview().offset(-0.5 * Dimensions.defaultSeparatorThickness)
        }
        
        horizontalSeparator.snp_makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }

}