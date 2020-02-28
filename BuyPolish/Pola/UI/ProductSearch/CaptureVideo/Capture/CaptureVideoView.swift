import UIKit

class CaptureVideoView: UIView {
    let productLabel = UILabel()
    let timeLabel = UILabel()
    let closeButton = UIButton(type: .custom)
    let startButton = UIButton(type: .custom)

    private let dimLayer = CAGradientLayer()
    
    var videoLayer: CALayer? {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        dimLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.insertSublayer(dimLayer, at: .zero)
        
        productLabel.font = Theme.titleFont
        productLabel.textColor = .white
        productLabel.numberOfLines = 0
        productLabel.lineBreakMode = .byWordWrapping
        addSubview(productLabel)
        
        timeLabel.font = Theme.titleFont
        timeLabel.textColor = .white
        addSubview(timeLabel)
        
        closeButton.accessibilityLabel = R.string.localizable.accessibilityClose()
        closeButton.setImage(R.image.closeIcon(), for: .normal)
        closeButton.tintColor = .white
        closeButton.sizeToFit()
        addSubview(closeButton)
        
        startButton.titleLabel?.font = Theme.buttonFont
        startButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        startButton.setTitle(R.string.localizable.captureVideoStart(), for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        addSubview(startButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let padding = CGFloat(16)
        let startButtonHeight = CGFloat(30)
        let dimMargin = CGFloat(30)
        
        closeButton.sizeToFit()
        closeButton.frameOrigin = CGPoint(
            x: bounds.width - padding - closeButton.frame.width,
            y: topSafeAreaInset + padding
        )
        
        let productLabelWidth = bounds.width - (CGFloat(3) * padding) - closeButton.frame.width
        productLabel.frame = CGRect(
            x: padding,
            y: topSafeAreaInset + padding,
            width: productLabelWidth,
            height: productLabel.height(forWidth: productLabelWidth)
        )
        
        dimLayer.frame = CGRect(
            origin: bounds.origin,
            size: CGSize(width: bounds.width, height: productLabel.frame.maxY - bounds.origin.x + dimMargin)
        )
        
        timeLabel.sizeToFit()
        timeLabel.center =  CGPoint(x: bounds.size.width / CGFloat(2), y: closeButton.frame.midY)
        
        startButton.frame = CGRect(
            x: padding,
            y: bounds.height - padding - startButtonHeight,
            width: bounds.width - (CGFloat(2) * padding),
            height: startButtonHeight
        )
    }
    
}
