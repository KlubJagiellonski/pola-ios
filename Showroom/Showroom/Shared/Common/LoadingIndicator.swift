import UIKit

class LoadingIndicator: UIView {
    private let dotsDistanceFromCenter = 20.0
    private let dotsMinRadius = 1.0
    private let dotsMaxRadius = 5.0
    private let numberOfDots = 3
    
    private var dots: [UIView] = []
    
    private var animating: Bool {
        return layer.animationForKey("rotationAnimation") != nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<numberOfDots {
            let dot = UIView()
            dot.backgroundColor = UIColor.blackColor()
            dot.frame = CGRect(x: 0, y: 0, width: dotsMaxRadius * 2, height: dotsMaxRadius * 2)
            dot.layer.cornerRadius = CGFloat(dotsMaxRadius)
            addSubview(dot)
            dots.append(dot)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index, dot) in dots.enumerate() {
            let angle = 2 * M_PI * Double(index) / Double(dots.count)
            let x = dotsDistanceFromCenter * cos(angle)
            let y = dotsDistanceFromCenter * sin(angle)
            let cx = bounds.width / 2
            let cy = bounds.height / 2
            dot.center = CGPoint(x: cx + CGFloat(x), y: cy + CGFloat(y))
        }
    }
    
    func startAnimation(animationTime: NSTimeInterval = 2) {
        guard !animating else { return }
        
        // Rotation animation of circles
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = animationTime * 2
        animationGroup.repeatCount = Float.infinity
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.toValue = M_PI * 4
        rotationAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotationAnim.duration = animationTime
        
        animationGroup.animations = [rotationAnim]
        layer.addAnimation(animationGroup, forKey: "rotationAnimation")
        
        // Animation of each circle
        dots.forEach { dot in
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = animationTime * 2
            animationGroup.repeatCount = Float.infinity
            
            let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.fromValue = NSValue(CGSize: CGSize(width: 1, height: 1))
            pulseAnimation.toValue = NSValue(CGSize: CGSize(width: dotsMinRadius / dotsMaxRadius,
                height: dotsMinRadius / dotsMaxRadius))
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.duration = animationTime / 2
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = 2
            pulseAnimation.beginTime = animationTime
            
            animationGroup.animations = [pulseAnimation]
            dot.layer.addAnimation(animationGroup, forKey: "pulseAnimation")
        }
    }
    
    func stopAnimation() {
        guard animating else { return }
        
        layer.removeAnimationForKey("rotationAnimation")
        dots.forEach { $0.layer.removeAllAnimations() }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return intrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let size: CGFloat = CGFloat(dotsDistanceFromCenter + dotsMaxRadius) * 2
        return CGSizeMake(size, size)
    }
}