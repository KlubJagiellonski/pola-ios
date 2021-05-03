import UIKit

final class SecondaryProgressView: UIView {
    private let filledProgressView = UIView()
    private let percentLabel = UILabel()
    private let titleVerticalMargin = CGFloat(10)

    var fillColor = Theme.lightBackgroundColor {
        didSet {
            filledProgressView.backgroundColor = fillColor
        }
    }

    var percentColor = Theme.defaultTextColor {
        didSet {
            percentLabel.textColor = percentColor
        }
    }

    var progress: CGFloat? {
        didSet {
            let text: String
            if let progress = progress {
                let points = Int(progress * 100)
                text = "\(points)%"
            } else {
                text = "?"
            }
            percentLabel.text = text
            percentLabel.sizeToFit()
            accessibilityValue =
                R.string.localizable.accessibilitySecondaryProgressValue(text)
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        filledProgressView.backgroundColor = fillColor
        addSubview(filledProgressView)

        percentLabel.font = Theme.captionFont
        percentLabel.textColor = percentColor
        percentLabel.text = "?"
        addSubview(percentLabel)

        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        var rect = CGRect(origin: .zero, size: bounds.size)
        if let progress = progress {
            rect.size.width = bounds.width * progress
        }
        filledProgressView.frame = rect

        let percentLabelRequiredSpace = CGFloat(percentLabel.bounds.width + (2 * titleVerticalMargin))

        rect = percentLabel.frame
        if percentLabelRequiredSpace > filledProgressView.frame.width {
            rect.origin.x = filledProgressView.frame.maxX + titleVerticalMargin
        } else {
            rect.origin.x = filledProgressView.frame.maxX - titleVerticalMargin - percentLabel.frame.width
        }
        rect.origin.y = (bounds.height - percentLabel.bounds.height) / 2
        percentLabel.frame = rect
    }

    override var intrinsicContentSize: CGSize {
        return addMargins(to: percentLabel.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addMargins(to: percentLabel.sizeThatFits(size))
    }

    private func addMargins(to size: CGSize) -> CGSize {
        let preferredHorizontalMargin = CGFloat(2)
        return CGSize(
            width: size.width + 2 * titleVerticalMargin,
            height: size.height + 2 * preferredHorizontalMargin
        )
    }
}
