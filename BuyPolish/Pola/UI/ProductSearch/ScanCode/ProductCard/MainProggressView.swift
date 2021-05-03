import UIKit

final class MainProggressView: UIView {
    private let filledProgressView = UIView()
    private let percentLabel = UILabel()
    private let titleMargin = CGFloat(10)
    private let barHeight = CGFloat(20)

    var progress = CGFloat(0) {
        didSet {
            let points = Int(progress * 100)
            let text = R.string.localizable.progressPoints(points)
            percentLabel.text = text
            percentLabel.sizeToFit()
            accessibilityValue = R.string.localizable.accessibilityMainProgressValue(text)
            invalidateIntrinsicContentSize()
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

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        var rect = CGRect.zero
        rect.size.width = bounds.width * progress
        rect.size.height = bounds.height
        filledProgressView.frame = rect

        rect = percentLabel.frame
        rect.origin.x = bounds.width - titleMargin - percentLabel.frame.width
        rect.origin.y = (bounds.height - percentLabel.bounds.height) / 2
        percentLabel.frame = rect
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: percentLabel.intrinsicContentSize.width + titleMargin,
            height: barHeight
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: percentLabel.sizeThatFits(size).width + titleMargin,
            height: barHeight
        )
    }
}
