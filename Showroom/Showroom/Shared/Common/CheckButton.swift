import UIKit

class CheckButton: UIControl {
    private static let checkBoxSize: CGFloat = 20
    private static let checkBoxTouchRange: CGFloat = 30
    private static let checkBoxMargin: CGFloat = 10
    
    private static let disabledColor = UIColor(named: .DarkGray)
    private static let enabledColor = UIColor(named: .Black)
    
    private let checkBoxImageView = UIImageView()
    private let boxView = UIView()
    let titleLabel = UILabel()
    let contentView = UIView()
    
    override var selected: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    init(title: String? = nil) {
        super.init(frame: CGRectZero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CheckButton.didTapView)))
        
        checkBoxImageView.image = UIImage(asset: .Ic_tick)
        
        titleLabel.font = UIFont(fontType: .FormNormal)
        titleLabel.text = title
        
        boxView.layer.borderColor = UIColor(named: .Black).CGColor
        boxView.layer.borderWidth = 1
        
        updateViewsState()
        
        boxView.addSubview(checkBoxImageView)
        addSubview(boxView)
        addSubview(titleLabel)
        addSubview(contentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView(recognizer: UITapGestureRecognizer) {
        let tappedCheck = recognizer.locationInView(self).x < CheckButton.checkBoxTouchRange
        if (tappedCheck) {
            selected = !selected
            sendActionsForControlEvents(.ValueChanged)
        } else {
            sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    private func configureCustomConstraints() {
        
        
        checkBoxImageView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        boxView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        boxView.snp_makeConstraints { make in
            make.width.equalTo(CheckButton.checkBoxSize)
            make.height.equalTo(CheckButton.checkBoxSize)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(boxView.snp_trailing).offset(CheckButton.checkBoxMargin)
            make.centerY.equalToSuperview()
        }
        
        contentView.snp_makeConstraints { make in
            make.leading.equalTo(boxView.snp_trailing).offset(CheckButton.checkBoxMargin)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func updateViewsState() {
        checkBoxImageView.hidden = !selected
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, max(checkBoxImageView.intrinsicContentSize().height, titleLabel.intrinsicContentSize().height, Dimensions.defaultCellHeight))
    }
}
