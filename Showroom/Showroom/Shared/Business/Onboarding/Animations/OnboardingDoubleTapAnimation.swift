import Foundation
import UIKit

class OnboardingDoubleTapAnimation: UIView {
    private let delayBeforeFirstAnimationCycle: NSTimeInterval = 0.5
    private let delayBeforeNextAnimationCycle: NSTimeInterval = 1.0
    
    private let screenTopOffset: CGFloat
    
    private let phoneImageView: UIImageView
    private let screenImageView: UIImageView
    private let heartMaskView: HeartMaskView
    private let touchIndicator = TouchIndicatorView()
    
    var animating = false {
        didSet {
            if animating {
                stopAnimation()
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_4))
            screenImageView = UIImageView(image: UIImage(asset: .Onb_img2_4))
            screenTopOffset = 55.8
            heartMaskView = HeartMaskView(frame: CGRect(x: 10, y: 50, width: 87, height: 114))
            
        case .iPhone5:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big))
            screenImageView = UIImageView(image: UIImage(asset: .Onb_img2_5))
            screenTopOffset = 67.8
            heartMaskView = HeartMaskView(frame: CGRect(x: 11, y: 60, width: 104, height: 135))
            
        case .iPhone6:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6))
            screenImageView = UIImageView(image: UIImage(asset: .Onb_img2_6))
            screenTopOffset = 75.8
            heartMaskView = HeartMaskView(frame: CGRect(x: 14, y: 69, width: 116, height: 151))
            
        case .iPhone6Plus:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6p))
            screenImageView = UIImageView(image: UIImage(asset: .Onb_img2_6p))
            screenTopOffset = 87.7
            heartMaskView = HeartMaskView(frame: CGRect(x: 16, y: 80, width: 134, height: 175))
            
        default:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6))
            screenImageView = UIImageView(image: UIImage(asset: .Onb_img2_6))
            screenTopOffset = 75.8
            heartMaskView = HeartMaskView(frame: CGRect(x: 14, y: 69, width: 116, height: 151))
        }
        
        super.init(frame: CGRectZero)
        
        touchIndicator.frame.origin = CGPoint(x: heartMaskView.center.x - touchIndicator.bounds.midX, y: heartMaskView.center.y - touchIndicator.bounds.midY)
        
        addSubview(screenImageView)
        addSubview(phoneImageView)
        screenImageView.addSubview(heartMaskView)
        screenImageView.addSubview(touchIndicator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        phoneImageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        screenImageView.snp_makeConstraints { make in
            make.centerX.equalTo(phoneImageView)
            make.top.equalTo(phoneImageView).offset(screenTopOffset)
        }
    }
    
    func startAnimation() {
        self.heartMaskView.hidden = true
        performSelector(#selector(OnboardingDoubleTapAnimation.animate), withObject: nil, afterDelay: delayBeforeFirstAnimationCycle)
    }
    
    func animate() {
        guard animating else { return }
        
        self.touchIndicator.animateDoubleTap(completion: { [weak self] _ in
            guard let `self` = self else { return }
            guard self.animating else { return }
            
            self.heartMaskView.hidden = false
            self.heartMaskView.animate(completion: { [weak self] _ in
                guard let `self` = self else { return }
                guard self.animating else { return }
                
                self.performSelector(#selector(OnboardingDoubleTapAnimation.animate), withObject: nil, afterDelay: self.delayBeforeNextAnimationCycle)
                })
            })
    }
    
    func stopAnimation() {
        touchIndicator.layer.removeAllAnimations()
        touchIndicator.touchUp()
        heartMaskView.removeTransformAnimation()
    }
}
