import UIKit

class CheckoutAddressOptionView: UIView {
    static let checkBoxToLeftOffset: CGFloat = 12.0
    static let checkBoxToLabelOffset: CGFloat = 21.0
    
    private static let disabledColor = UIColor(named: .DarkGray)
    private static let enabledColor = UIColor(named: .Black)
    
    private let checkBoxImageView = UIImageView()
    var addressLabel = UILabel()
    
    var enabled: Bool { didSet { updateViewsState() } }
    var selected: Bool { didSet { updateViewsState() } }
    
    init(title: String, selected: Bool) {
        enabled = true
        self.selected = selected
        super.init(frame: CGRectZero)
        
        checkBoxImageView.tintColor = CheckoutAddressOptionView.disabledColor
        
        addressLabel.backgroundColor = UIColor(named: .White)
        addressLabel.font = UIFont(fontType: .FormNormal)
        addressLabel.numberOfLines = 4
        addressLabel.lineBreakMode = .ByWordWrapping
        addressLabel.text = title
        
        updateViewsState()
        
        addSubview(checkBoxImageView)
        addSubview(addressLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        checkBoxImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(CheckoutAddressOptionView.checkBoxToLeftOffset)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        addressLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        addressLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        addressLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(CheckoutAddressOptionView.checkBoxToLabelOffset)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func updateViewsState() {
        addressLabel.textColor = enabled ? CheckoutAddressOptionView.enabledColor : CheckoutAddressOptionView.disabledColor
                
        var image = selected ? UIImage(asset: .Ic_checkbox_on) : UIImage(asset: .Ic_checkbox_off)
        if !enabled {
            image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        checkBoxImageView.image = image
    }
}