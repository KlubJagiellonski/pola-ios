import UIKit

class RadioButton: UIControl {
    private static let disabledColor = UIColor(named: .DarkGray)
    private static let enabledColor = UIColor(named: .Black)
    
    private let checkBoxImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentView = UIView()
    
    override var enabled: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    init(title: String) {
        super.init(frame: CGRectZero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RadioButton.didTapView)))
        
        checkBoxImageView.tintColor = RadioButton.disabledColor
        
        titleLabel.font = UIFont(fontType: .FormNormal)
        titleLabel.text = title
        
        updateViewsState()
        
        addSubview(checkBoxImageView)
        addSubview(titleLabel)
        addSubview(contentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView() {
        selected = !selected
        sendActionsForControlEvents(.ValueChanged)
    }
    
    private func configureCustomConstraints() {
        let horizontalMargin = 3
        
        checkBoxImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalMargin)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        contentView.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func updateViewsState() {
        titleLabel.textColor = enabled ? RadioButton.enabledColor : RadioButton.disabledColor
        
        var image = selected ? UIImage(asset: .Ic_checkbox_on) : UIImage(asset: .Ic_checkbox_off)
        if !enabled {
            image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        checkBoxImageView.image = image
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, max(checkBoxImageView.intrinsicContentSize().height, titleLabel.intrinsicContentSize().height, Dimensions.defaultCellHeight))
    }
}