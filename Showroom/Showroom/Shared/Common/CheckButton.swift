import UIKit

protocol CheckButtonDelegate: class {
    func checkButton(checkButton: CheckButton, wantsShowMessage message: String)
}

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
    
    weak var delegate: CheckButtonDelegate?
    
    override var selected: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    /// Tapable part of the label. Must be a substring of the title.
    var link: String? {
        didSet {
            guard let link = link else {
                return
            }
            guard let title = title else {
                return
            }
            
            if title.containsString(link) == true {
                let mutableAttributedText = NSMutableAttributedString(attributedString: title.stringWithHighlightedSubsttring(link))
                mutableAttributedText.addAttribute(NSFontAttributeName, value: titleLabel.font, range: NSRange(location: 0, length: mutableAttributedText.length))
                titleLabel.attributedText = mutableAttributedText
            } else {
                logError("Cannot set a link value that is not a substring of the title.")
            }
        }
    }
    
    init(title: String? = nil) {
        super.init(frame: CGRectZero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CheckButton.didTapView)))
        
        checkBoxImageView.image = UIImage(asset: .Ic_tick)
        
        titleLabel.backgroundColor = UIColor(named: .White)
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
        guard let attributedText = titleLabel.attributedText, let text = titleLabel.text, let link = link else {
            selected = !selected
            sendActionsForControlEvents(.ValueChanged)
            return
        }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: titleLabel.bounds.size)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        
        let linkRange = (text as NSString).rangeOfString(link)
        var glyphRange:NSRange = NSRange()
        layoutManager.characterRangeForGlyphRange(linkRange, actualGlyphRange: &glyphRange)
        
        let linkBox = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
        
        if linkBox.contains(recognizer.locationInView(titleLabel)) {
            sendActionsForControlEvents(.TouchUpInside)
        } else {
            selected = !selected
            sendActionsForControlEvents(.ValueChanged)
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

extension CheckButton: ContentValidator {
    func getValue() -> AnyObject? {
        return self.selected
    }
    
    func showError(error: String) {
        delegate?.checkButton(self, wantsShowMessage: error)
    }
    
    func hideError() {}
}
