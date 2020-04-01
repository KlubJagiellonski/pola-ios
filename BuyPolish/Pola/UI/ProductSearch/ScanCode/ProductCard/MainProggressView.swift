import UIKit

final class MainProggressView: UIView {
    
    private let filledProgressView = UIView()
    private let percentLabel = UILabel()
    
    var progress = CGFloat(0) {
        didSet {
            let points = Int(progress * 100)
            let text = R.string.localizable.progressPoints(points)
            percentLabel.text = text
            percentLabel.sizeToFit()
            accessibilityValue = R.string.localizable.accessibilityMainProgressValue(text)
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.lightBackgroundColor
        
        filledProgressView.backgroundColor = Theme.actionColor
        addSubview(filledProgressView)
        
        percentLabel.font = Theme.captionFont
        percentLabel.textColor = Theme.clearColor
        addSubview(percentLabel)
        
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        rect.size.width = bounds.width * progress
        rect.size.height = bounds.height
        filledProgressView.frame = rect
        
        let titleMargin = CGFloat(10)
        rect = percentLabel.frame
        rect.origin.x = bounds.width - titleMargin - percentLabel.frame.width
        rect.origin.y = (bounds.height - percentLabel.bounds.height) / 2
        percentLabel.frame = rect
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 20)
    }
    
}
