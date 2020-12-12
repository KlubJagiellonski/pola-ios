import UIKit

final class KeyboardView: UIView {
    private let contentView = UIView()
    let textView = KeyboardTextView()
    let numberButtons = (1 ... 10).map { _ in ExtendedButton() }
    let okButton = UIButton()
    let infoTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        addSubview(contentView)
        contentView.addSubview(textView)

        numberButtons.enumerated().forEach { offset, button in
            let number = (offset + 1) % 10

            button.extendedTouchSize = 4
            button.tag = number
            button.accessibilityLabel = "\(number)"
            button.setImage(UIImage(named: "kb_\(number)"), for: .normal)
            button.setImage(UIImage(named: "kb_\(number)_highlighted"), for: .highlighted)
            contentView.addSubview(button)
        }

        okButton.accessibilityLabel = R.string.localizable.accessibilityKeyboardAccept()
        okButton.setImage(R.image.kb_ok(), for: .normal)
        okButton.setImage(R.image.kb_ok_highlighted(), for: .highlighted)
        contentView.addSubview(okButton)

        infoTextLabel.text = R.string.localizable.typeOrPasteCode()
        infoTextLabel.numberOfLines = 4
        infoTextLabel.font = Theme.titleFont
        infoTextLabel.textColor = Theme.clearColor
        infoTextLabel.textAlignment = .center
        infoTextLabel.sizeToFit()
        addSubview(infoTextLabel)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let buttonMargin = CGFloat(18.0)
        let sizedButton = numberButtons.first!
        sizedButton.sizeToFit()
        let buttonSize = sizedButton.bounds.size
        let buttonsInRow = 3
        let buttonRows = 4
        let verticalMargin = CGFloat(16.0)
        let infoTextLabelBottomMargin = CGFloat(50.0)
        let horizontalInfoTextMargin = CGFloat(15.0)

        textView.sizeToFit()
        let contentWidth = (buttonSize.width * CGFloat(buttonsInRow)) + (buttonMargin * CGFloat(buttonsInRow - 1))
        let contentHeight = textView.frame.height
            + verticalMargin
            + (buttonSize.height * CGFloat(buttonRows))
            + (buttonMargin * CGFloat(buttonRows - 1))

        contentView.frame = CGRect(
            x: (bounds.width / CGFloat(2.0)) - (contentWidth / CGFloat(2.0)),
            y: (bounds.height / CGFloat(2.0)) - (contentHeight / CGFloat(2.0)),
            width: contentWidth,
            height: contentHeight
        )

        let textViewHeight = textView.bounds.height
        textView.frameSize = CGSize(width: contentWidth, height: textViewHeight)

        var buttonPosition = CGPoint(x: .zero, y: textView.frame.maxY + verticalMargin)
        var column = 0
        numberButtons.forEach { button in
            button.frame = CGRect(origin: buttonPosition, size: buttonSize)
            column += 1
            if column == buttonsInRow {
                buttonPosition.x = 0
                buttonPosition.y += buttonSize.height + buttonMargin
                column = 0
            } else {
                buttonPosition.x += buttonSize.width + buttonMargin
            }
        }

        okButton.sizeToFit()
        okButton.frameOrigin = CGPoint(x: contentWidth - okButton.frame.width, y: contentHeight - okButton.frame.height)

        let widthLabel = bounds.width - (2 * horizontalInfoTextMargin)
        let heightLabel = infoTextLabel.height(forWidth: widthLabel)
        infoTextLabel.frame = CGRect(
            x: horizontalInfoTextMargin,
            y: bounds.height - infoTextLabelBottomMargin - heightLabel,
            width: widthLabel,
            height: heightLabel
        )
    }
}
