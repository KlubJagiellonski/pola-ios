import UIKit

protocol UserInfoContainerViewDelegate: class {
    func userInfoContainerViewDidTapDescription(view: UserInfoContainerView)
}

class UserInfoContainerView: UIView {
    
    private let descriptionLabel = UILabel()
    private let nameStackView = NameStackView()
    private let addressesHeaderLabel = UILabel()
    private let addressesStackView = UIStackView()
    
    private let separators: [UIView]
    
    var name: String {
        get { return nameStackView.rightText ?? "" }
        set { nameStackView.rightText = newValue }
    }
    
    weak var delegate: UserInfoContainerViewDelegate?
    
    init() {
        separators = [UIView(), UIView()]
        separators.forEach { $0.backgroundColor = UIColor(named: .Separator) }
        
        super.init(frame: CGRectZero)
        
        let linkString = tr(.SettingsUserDataDescriptionWebsite)
        descriptionLabel.attributedText = tr(.SettingsUserDataDescription(linkString)).stringWithHighlightedSubsttring(linkString)
        descriptionLabel.font = UIFont.georgiaItalic(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .ByWordWrapping
        
        addressesStackView.axis = .Vertical
        addressesStackView.spacing = 30.0
        
        addressesHeaderLabel.text = tr(.SettingsUserDataAddresses)
        addressesHeaderLabel.font = UIFont.latoBold(ofSize: 14)
        
        addSubview(descriptionLabel)
        addSubview(nameStackView)
        addSubview(addressesHeaderLabel)
        addSubview(addressesStackView)
        separators.forEach { addSubview($0) }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserInfoContainerView.didTapDescription))
        descriptionLabel.addGestureRecognizer(tap)
        descriptionLabel.userInteractionEnabled = true
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(user user: User) {
        self.name = user.name
        
        for view in addressesStackView.arrangedSubviews {
            addressesStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for address in user.userAddresses {
            let addressLabel = UILabel()
            let descriptionString = address.description != nil ? "(\(address.description!))\n" : ""
            addressLabel.text = "\(address.firstName) \(address.lastName)\n\(address.streetAndAppartmentNumbers)\n\(address.postalCode) \(address.city)\n\(address.country)\n\(descriptionString)\(address.phone)"
            
            addressLabel.font = UIFont(fontType: .Normal)
            addressLabel.numberOfLines = 0
            addressLabel.lineBreakMode = .ByWordWrapping
            addressesStackView.addArrangedSubview(addressLabel)
        }
    }
    
    func didTapDescription() {
        delegate?.userInfoContainerViewDidTapDescription(self)
    }
    
    func configureCustomConstraints() {
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(39.0)
            make.leading.equalToSuperview().offset(18.0)
            make.trailing.equalToSuperview().offset(-18.0)
        }
        separators[0].snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(37.0)
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        nameStackView.snp_makeConstraints { make in
            make.top.equalTo(separators[0].snp_bottom)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        separators[1].snp_makeConstraints { make in
            make.top.equalTo(nameStackView.snp_bottom)
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        addressesHeaderLabel.snp_makeConstraints { make in
            make.height.equalTo(43.0)
            make.top.equalTo(separators[1].snp_bottom)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        addressesStackView.snp_makeConstraints { make in
            make.top.equalTo(addressesHeaderLabel.snp_bottom)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview()
        }
    }
}

private class NameStackView: UIStackView {
    var leftLabel = UILabel()
    var rightLabel = UILabel()
    
    var rightText: String {
        get { return rightLabel.text! }
        set { rightLabel.text = newValue }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        leftLabel.text = tr(.SettingsUserDataName)
        leftLabel.font = UIFont.latoBold(ofSize: 14)
        leftLabel.textAlignment = .Left
        rightLabel.font = UIFont.latoRegular(ofSize: 14)
        rightLabel.textAlignment = .Right
        
        addArrangedSubview(leftLabel)
        addArrangedSubview(rightLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Dimensions.defaultCellHeight - Dimensions.defaultSeparatorThickness)
    }
}