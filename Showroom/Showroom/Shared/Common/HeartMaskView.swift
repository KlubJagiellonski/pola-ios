import UIKit

class HeartMaskView: UIView {
    
    let rectHeartLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        
        rectHeartLayer.fillRule = kCAFillRuleEvenOdd
        rectHeartLayer.fillColor = UIColor.grayColor().CGColor
        rectHeartLayer.opacity = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var firstLayoutSubviews = true
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if firstLayoutSubviews {
            firstLayoutSubviews = false
            rectHeartLayer.path = createRectHeartPath(frame.size).CGPath
        }
    }
    
    var currentAnimationKey: String?
    func animate(duration duration: NSTimeInterval = 1.5, completion: (() -> ())? = nil) {
        if rectHeartLayer.superlayer == nil {
            layer.addSublayer(rectHeartLayer)
        }
        
        let animationKey = String(NSDate().timeIntervalSince1970)
        currentAnimationKey = animationKey
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [weak self] in
            guard let `self` = self else { return }
            
            self.rectHeartLayer.removeFromSuperlayer()
            if animationKey == self.currentAnimationKey {
                completion?()
            } 
        })
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
            let scaleAnimation = CABasicAnimation(keyPath: "transform")
            scaleAnimation.duration = duration
            let layerSize = layer.bounds.size
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, CGFloat(layerSize.width/2), CGFloat(layerSize.height/2), 0)
            transform = CATransform3DScale(transform, 30.0, 30.0, 1.0)
            transform = CATransform3DTranslate(transform, CGFloat(-layerSize.width/2), CGFloat(-layerSize.height/2), 0)
            
            scaleAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
            scaleAnimation.toValue = NSValue(CATransform3D: transform)
            rectHeartLayer.addAnimation(scaleAnimation, forKey: "transformAnimation")
            
            rectHeartLayer.transform = transform
        
        CATransaction.commit()
    }
    
    func removeTransformAnimation() {
        currentAnimationKey = nil
        layer.removeAnimationForKey("transformAnimation")
    }
    
    private func createRectHeartPath(size: CGSize) -> UIBezierPath {
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        let heartPath = UIBezierPath()
        heartPath.moveToPoint(CGPoint(x: 70.88, y: 56.36))
        heartPath.addCurveToPoint(CGPoint(x: 10.26, y: 52.68), controlPoint1: CGPoint(x: 39.06, y: 20.62), controlPoint2: CGPoint(x: 14.43, y: 45.31))
        heartPath.addCurveToPoint(CGPoint(x: 17.84, y: 96.9), controlPoint1: CGPoint(x: 2.69, y: 66.31), controlPoint2: CGPoint(x: 7.23, y: 86.95))
        heartPath.addLineToPoint(CGPoint(x: 70.88, y: 148.5))
        heartPath.addLineToPoint(CGPoint(x: 123.92, y: 96.9))
        heartPath.addCurveToPoint(CGPoint(x: 131.5, y: 52.68), controlPoint1: CGPoint(x: 134.53, y: 86.95), controlPoint2: CGPoint(x: 139.07, y: 66.31))
        heartPath.addCurveToPoint(CGPoint(x: 70.88, y: 56.36), controlPoint1: CGPoint(x: 127.33, y: 45.31), controlPoint2: CGPoint(x: 101.19, y: 20.62))
        heartPath.closePath()
        
        heartPath.applyTransform(CGAffineTransformMakeScale(0.1, 0.1))
        heartPath.applyTransform(CGAffineTransformMakeTranslation(-heartPath.bounds.minX + CGFloat(size.width/2.0) - CGFloat(heartPath.bounds.width/2.0), -heartPath.bounds.minY + CGFloat(size.height/2.0) - CGFloat(heartPath.bounds.height/2.0)))
        
        rectPath.appendPath(heartPath)
        
        rectPath.usesEvenOddFillRule = true
        
        return rectPath
    }
}