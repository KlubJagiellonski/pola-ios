import UIKit

class ResultsView: UIView {
    private let stackView: CardStackView
    let infoTextLabel = UILabel()
    let teachButton = UIButton(type: .custom)
    
    init(frame: CGRect, stackView: CardStackView) {
        self.stackView = stackView
        super.init(frame: frame)
        
        infoTextLabel.text = R.string.localizable.scanBarcode()
        infoTextLabel.numberOfLines = 4
        infoTextLabel.font = Theme.titleFont
        infoTextLabel.textColor = Theme.clearColor
        infoTextLabel.textAlignment = .center
        infoTextLabel.sizeToFit()
        addSubview(infoTextLabel)
        
        addSubview(stackView)
        
        teachButton.accessibilityLabel = R.string.localizable.accessibilityTeachPola()
        teachButton.titleLabel?.font = Theme.buttonFont
        teachButton.layer.borderColor = Theme.defaultTextColor.cgColor
        teachButton.layer.borderWidth = 1
        teachButton.setTitleColor(UIColor.black, for: .normal)
        teachButton.setBackgroundImage(UIImage.image(color: UIColor.white.withAlphaComponent(0.7)), for: .normal)
        teachButton.setBackgroundImage(UIImage.image(color: UIColor.white), for: .highlighted)
        teachButton.sizeToFit()
        teachButton.isHidden = true
        addSubview(teachButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var infoTextVisible = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.infoTextLabel.alpha = self.infoTextVisible ? 1.0 : 0.0
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scanCodeMargin = CGFloat(15.0)
        let infoTextLabelBottomMargin = CGFloat(50.0)
        let scanCodeTechButtonOffset = CGFloat(10.0)
        let scanCodeTechButtonHeight = CGFloat(35.0)

        stackView.frame = bounds
    
        let widthLabel = bounds.width - (2 * scanCodeMargin)
        let heightLabel = infoTextLabel.height(forWidth: widthLabel)
        infoTextLabel.frame = CGRect(
            x: scanCodeMargin,
            y: bounds.height - infoTextLabelBottomMargin - heightLabel,
            width: widthLabel,
            height: heightLabel
        )
        
        teachButton.frame = CGRect(
            x: scanCodeMargin,
            y: bounds.height - stackView.cardsHeight - scanCodeTechButtonHeight - scanCodeTechButtonOffset,
            width: bounds.width - (2 * scanCodeMargin),
            height: scanCodeTechButtonHeight
        )
    }
    
}
