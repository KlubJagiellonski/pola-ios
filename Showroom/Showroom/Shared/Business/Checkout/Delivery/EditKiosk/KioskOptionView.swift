import UIKit

protocol KioskOptionViewDelegate: class {
    func kioskOptionViewDidTap(view: KioskOptionView)
}

class KioskOptionView: UIView {
    static let checkBoxToLeftOffset: CGFloat = 27.0
    static let checkBoxToTitleLabelOffset: CGFloat = 21.0
    static let checkBoxSide: CGFloat = 22.0
    static let titleLabelToTopInset: CGFloat = 0.0
    static let titleLabelToDistanceLabelOffset: CGFloat = 5.0
    static let distanceLabelToDescriptionLabelOffset: CGFloat = 5.0
    static let descriptionLabelToBottomInset: CGFloat = 25.0
    
    private static let disabledColor = UIColor(named: .DarkGray)
    private static let enabledColor = UIColor(named: .Black)
    
    private let checkBoxImageView = UIImageView()
    var titleLabel = UILabel()
    let distanceLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var enabled: Bool { didSet { updateViewsState() } }
    var selected: Bool { didSet { updateViewsState() } }
    
    weak var delegate: KioskOptionViewDelegate?
    
    init(kiosk: Kiosk, selected: Bool) {
        enabled = true
        self.selected = selected
        super.init(frame: CGRectZero)
        
        checkBoxImageView.tintColor = KioskOptionView.disabledColor
        addSubview(checkBoxImageView)
        
        titleLabel.font = UIFont(fontType: .FormNormal)
        titleLabel.text = kiosk.city + " " + kiosk.street
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        addSubview(titleLabel)
        
        let distanceString = (kiosk.distance < 1) ? String(Int(round(kiosk.distance*1000))) + " m" : String(format: "%.1f", kiosk.distance) + " km"
        distanceLabel.text = distanceString
        distanceLabel.font = UIFont(fontType: .FormNormal)
        addSubview(distanceLabel)
        
        descriptionLabel.font = UIFont(fontType: .Description)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.text = kiosk.displayName + "\n" + kiosk.workingHours.joinWithSeparator("\n")
        addSubview(descriptionLabel)
        
        updateViewsState()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KioskOptionView.didTap))
        addGestureRecognizer(tap)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap() {
        delegate?.kioskOptionViewDidTap(self)
    }
    
    private func configureCustomConstraints() {
        checkBoxImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(KioskOptionView.checkBoxToLeftOffset)
            make.top.equalToSuperview().inset(KioskOptionView.titleLabelToTopInset)
            make.bottom.lessThanOrEqualToSuperview()
            make.width.equalTo(KioskOptionView.checkBoxSide)
            make.height.equalTo(KioskOptionView.checkBoxSide)
        }
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(KioskOptionView.checkBoxToTitleLabelOffset)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(KioskOptionView.titleLabelToTopInset)
//            make.width.equalTo(300.0)
        }
        
        distanceLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        distanceLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(KioskOptionView.checkBoxToTitleLabelOffset)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp_bottom).offset(KioskOptionView.titleLabelToDistanceLabelOffset)
        }
        
        descriptionLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        descriptionLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(KioskOptionView.checkBoxToTitleLabelOffset)
            make.trailing.equalToSuperview()
            make.top.equalTo(distanceLabel.snp_bottom).offset(KioskOptionView.distanceLabelToDescriptionLabelOffset)
            make.bottom.equalToSuperview().inset(KioskOptionView.descriptionLabelToBottomInset)
        }
    }
    
    private func updateViewsState() {
        titleLabel.textColor = enabled ? KioskOptionView.enabledColor : KioskOptionView.disabledColor
        descriptionLabel.textColor = enabled ? KioskOptionView.enabledColor : KioskOptionView.disabledColor
        
        var image = selected ? UIImage(asset: .Ic_checkbox_on) : UIImage(asset: .Ic_checkbox_off)
        if !enabled {
            image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        checkBoxImageView.image = image
    }
}