import Foundation
import UIKit

final class PromoSummaryPlayControl: UIControl {
    private let animationDuration: NSTimeInterval = 5
    
    weak var playerView: PromoSummaryPlayerView?
    var progressVisible = true {
        didSet {
            progressLayer.opacity = progressVisible ? 1 : 0
        }
    }
    
    private var animationInProgressTimestamp: NSTimeInterval?
    
    private let startAngle: CGFloat
    private let endAngle: CGFloat
    
    private let button = UIButton()
    private let progressLayer = CAShapeLayer()
    
    init() {
        startAngle = CGFloat(M_PI)
        endAngle = startAngle + CGFloat(M_PI * 2)
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        
        button.layer.cornerRadius = Dimensions.mediaPlayButtonDiameter * 0.5
        button.clipsToBounds = true
        let color = UIColor(named: .White).colorWithAlphaComponent(0.3)
        button.setBackgroundImage(UIImage.fromColor(color), forState: .Normal)
        button.setImage(UIImage(asset: .Play_next), forState: .Normal)
        
        progressLayer.strokeColor = UIColor.blackColor().CGColor
        progressLayer.fillColor = UIColor.clearColor().CGColor
        progressLayer.lineWidth = 3
        
        addSubview(button)
        layer.addSublayer(progressLayer)
        
        button.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressLayer.path = createProgressPath()
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        button.addTarget(target, action: action, forControlEvents: controlEvents)
    }
    
    func invalidateAndStartAnimation() {
        self.animationInProgressTimestamp = nil
        progressLayer.removeAllAnimations()
        
        CATransaction.begin()
        
        let animationInProgressTimestamp = NSDate().timeIntervalSince1970
        self.animationInProgressTimestamp = animationInProgressTimestamp
        CATransaction.setCompletionBlock { [weak self] in
            guard let `self` = self else { return }
            guard animationInProgressTimestamp == self.animationInProgressTimestamp else { return }
            self.playerView?.didFinishedPlayControlAnimation(with: self)
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationDuration
        animation.fromValue = 1
        animation.toValue = 0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        progressLayer.addAnimation(animation, forKey: "test")
        
        CATransaction.commit()
    }
    
    private func createProgressPath() -> CGPathRef {
        let bezierPath = UIBezierPath()
        bezierPath.addArcWithCenter(
            CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2),
            radius: bounds.size.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        return bezierPath.CGPath
    }
    
}
