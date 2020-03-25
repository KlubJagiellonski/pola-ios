import UIKit

class ScannerCodeView: UIView {
    
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
    
    let rectangleView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        rectangleView.layer.borderWidth = 1
        rectangleView.layer.borderColor = UIColor.white.cgColor
        rectangleView.accessibilityTraits = .notEnabled
        rectangleView.isAccessibilityElement = true
        rectangleView.accessibilityHint = R.string.localizable.accessibilityRectangleHint()
        addSubview(rectangleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = rectangleView.frame
        rect.size.width = bounds.width / 1.4
        rect.size.height = rect.size.width / 2.0
        rect.origin.x = (bounds.width / 2) - (rect.width / 2)
        rect.origin.y = (bounds.height / 2) - rect.height
        rectangleView.frame = rect
        
        videoLayer?.frame = layer.bounds
    }
}
