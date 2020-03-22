import UIKit

@objc(BPScanCodeView)
class ScanCodeView: UIView {
    
    @objc
    let logoImageView = UIImageView(image: R.image.logoIcon())
    
    @objc
    let menuButton = UIButton(type: .custom)
    
    @objc
    let flashButton = UIButton(type: .custom)
    
    @objc
    let keyboardButton = UIButton(type: .custom)
    
    @objc
    var buttonsVisible = true {
        didSet {
            let alpha = CGFloat(buttonsVisible ? 1.0 : 0.0)
            UIView.animate(withDuration: 0.3) {
                self.menuButton.alpha = alpha
                self.flashButton.alpha = alpha
                self.keyboardButton.alpha = alpha
            }
        }
    }
    
    private let dimView = UIImageView(image: R.image.gradientImage())

    @objc
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dimView)
        
        logoImageView.sizeToFit()
        addSubview(logoImageView)
                        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scanCodeMargin = CGFloat(15.0)

        dimView.frame = bounds
    
        let topY = topSafeAreaInset + scanCodeMargin
        var rect = keyboardButton.frame
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
    }

}
