import UIKit

@objc(BPScanCodeView)
class ScanCodeView: UIView {
    
    private let stackView: CardStackView
    
    @objc
    let infoTextLabel = UILabel()
    
    @objc
    let rectangleView = UIView()
    
    @objc
    let logoImageView = UIImageView(image: R.image.logoIcon())
    
    @objc
    let menuButton = UIButton(type: .custom)
    
    @objc
    let flashButton = UIButton(type: .custom)
    
    @objc
    let keyboardButton = UIButton(type: .custom)
    
    @objc
    let teachButton = UIButton(type: .custom)
    
    @objc
    var videoLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperlayer()
            }
            guard let videoLayer = videoLayer  else {
                return
            }
            videoLayer.frame = layer.bounds
            layer.insertSublayer(videoLayer, at: 0)
        }
    }
    
    @objc
    var infoTextVisible = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.infoTextLabel.alpha = self.infoTextVisible ? 1.0 : 0.0
            }
        }
    }
    
    @objc
    var buttonsVisible = true {
        didSet {
            let alpha = CGFloat(buttonsVisible ? 1.0 : 0.0)
            UIView.animate(withDuration: 0.3) {
                self.menuButton.alpha = alpha
                self.flashButton.alpha = alpha
                self.keyboardButton.alpha = alpha
                if self.buttonsVisible {
                    self.teachButton.alpha = alpha
                }
            }
            if !buttonsVisible {
                teachButton.alpha = alpha
            }
        }
    }
    
    private let dimView = UIImageView(image: R.image.gradientImage())

    @objc
    init(frame: CGRect, stackView: CardStackView) {
        self.stackView = stackView
        super.init(frame: frame)
        
        addSubview(dimView)
        
        rectangleView.layer.borderWidth = 1
        rectangleView.layer.borderColor = UIColor.white.cgColor
        rectangleView.accessibilityTraits = .notEnabled
        rectangleView.isAccessibilityElement = true
        rectangleView.accessibilityHint = R.string.localizable.accessibilityRectangleHint()
        addSubview(rectangleView)
        
        logoImageView.sizeToFit()
        addSubview(logoImageView)
        
        infoTextLabel.numberOfLines = 4
        infoTextLabel.font = Theme.titleFont
        infoTextLabel.textColor = Theme.clearColor
        infoTextLabel.textAlignment = .center
        infoTextLabel.sizeToFit()
        addSubview(infoTextLabel)
        
        addSubview(stackView)
        
        flashButton.accessibilityLabel = R.string.localizable.accessibilityFlash()
        flashButton.setImage(R.image.flashIcon(), for: .normal)
        flashButton.setImage(R.image.flashSelectedIcon(), for: .selected)
        flashButton.sizeToFit()
        insertSubview(flashButton, belowSubview: logoImageView)
        
        menuButton.accessibilityLabel = R.string.localizable.accessibilityInfo()
        menuButton.setImage(R.image.burgerIcon(), for: .normal)
        menuButton.sizeToFit()
        addSubview(menuButton)
        
        keyboardButton.accessibilityLabel = R.string.localizable.accessibilityWriteCode()
        keyboardButton.setImage(R.image.keyboardIcon(), for: .normal)
        keyboardButton.setImage(R.image.keyboardSelectedIcon(), for: .selected)
        keyboardButton.sizeToFit()
        addSubview(keyboardButton)

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scanCodeMargin = CGFloat(15.0)
        let infoTextLabelBottomMargin = CGFloat(50.0)
        let scanCodeTechButtonOffset = CGFloat(10.0)
        let scanCodeTechButtonHeight = CGFloat(35.0)

        stackView.frame = bounds
        dimView.frame = bounds
        
        var rect = rectangleView.frame
        rect.size.width = bounds.width / 1.4
        rect.size.height = rect.size.width / 2.0
        rect.origin.x = (bounds.width / 2) - (rect.width / 2)
        rect.origin.y = (bounds.height / 2) - rect.height
        rectangleView.frame = rect
        
        let topY = topSafeAreaInset + scanCodeMargin
        rect = keyboardButton.frame
        rect.origin.x = scanCodeMargin
        rect.origin.y = topY
        keyboardButton.frame = rect
        
        rect = flashButton.frame
        rect.origin.x = scanCodeMargin
        rect.origin.y = scanCodeMargin + keyboardButton.frame.maxY
        flashButton.frame = frame
        
        rect = menuButton.frame
        rect.origin.x = bounds.width - scanCodeMargin - rect.width
        rect.origin.y = topY
        menuButton.frame = rect
        
        rect = logoImageView.frame
        rect.origin.x = (bounds.width / 2) - (rect.width / 2)
        rect.origin.y = menuButton.frame.minY + (menuButton.bounds.height / 2) - (rect.height / 2)
        logoImageView.frame = rect
        
        rect = infoTextLabel.frame
        rect.size.width = bounds.width - (2 * scanCodeMargin)
        rect.size.height = infoTextLabel.height(forWidth: rect.size.width)
        rect.origin.x = scanCodeMargin
        rect.origin.y = bounds.height - infoTextLabelBottomMargin - rect.height
        infoTextLabel.frame = rect
        
        rect = teachButton.frame
        rect.size.height = scanCodeTechButtonHeight
        rect.size.width = bounds.width - (2 * scanCodeMargin)
        rect.origin.x = scanCodeMargin
        rect.origin.y = bounds.height - stackView.cardsHeight - scanCodeTechButtonHeight - scanCodeTechButtonOffset
        teachButton.frame = rect
    }
    

}
