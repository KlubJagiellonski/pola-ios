import Foundation
import UIKit
import SnapKit

enum Side {
    case Left, Right
    var opposite: Side { return (self == .Left) ? .Right : .Left }
}

enum ScreenContentPage {
    case First
    case Second(direction: Side)
    case Third
    
    var nextDirection: Side {
        switch self {
        case .First: return .Right
        case .Second(let direction): return direction
        case .Third: return .Left
        }
    }
    mutating func setNext() {
        switch self {
        case .First: self = .Second(direction: .Right)
        case .Second(direction: .Right): self = .Third
        case .Third: self = .Second(direction: .Left)
        case .Second(direction: .Left): self = .First
        }
    }
}

class OnboardingProductPagingAnimation: UIView {
    private let firstPageContentToPhoneHorizontalOffset: CGFloat
    private let contentToPhoneVerticalOffset: CGFloat
    private let touchIndicatorToPhoneOffsetX: CGFloat = 50.0
    private let touchIndicatorToPhoneOffsetY: CGFloat = 200.0
    
    private let phoneImageView: UIImageView
    private let screenContentImageView: UIImageView
    
    private let touchIndicator = TouchIndicatorView()
    
    private var screenContentLeadingConstraint: Constraint!
    
    private var visibleScreenContentPage: ScreenContentPage {
        didSet {
            switch visibleScreenContentPage {
            case .First:
                screenContentLeadingConstraint.updateOffset(firstPageContentToPhoneHorizontalOffset)
            case .Second:
                screenContentLeadingConstraint.updateOffset(firstPageContentToPhoneHorizontalOffset - (screenContentImageView.bounds.width / 3))
            case .Third:
                screenContentLeadingConstraint.updateOffset(firstPageContentToPhoneHorizontalOffset - (screenContentImageView.bounds.width * 2 / 3))
            }
        }
    }
    
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
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_3_4))
            firstPageContentToPhoneHorizontalOffset = 14.0
            contentToPhoneVerticalOffset = 57.0
            
        case .iPhone5:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_3))
            firstPageContentToPhoneHorizontalOffset = 15.0
            contentToPhoneVerticalOffset = 66.0
            
        case .iPhone6:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_3_6))
            firstPageContentToPhoneHorizontalOffset = 19.0
            contentToPhoneVerticalOffset = 77.0
            
        case .iPhone6Plus:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6p))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_3_6p))
            firstPageContentToPhoneHorizontalOffset = 22.0
            contentToPhoneVerticalOffset = 89.0
            
        default:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_3_6))
            firstPageContentToPhoneHorizontalOffset = 19.0
            contentToPhoneVerticalOffset = 77.0
        }
        
        visibleScreenContentPage = .First
        
        super.init(frame: CGRectZero)
        
        moveTouchIndicator(toSide: visibleScreenContentPage.nextDirection)
        
        addSubview(screenContentImageView)
        addSubview(phoneImageView)
        phoneImageView.addSubview(touchIndicator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        guard animating else { return }
        
        screenContentImageView.layoutIfNeeded()
        touchIndicator.layoutIfNeeded()
        
        // touch indicator initial position
        let touchIndicatorInitialSide = visibleScreenContentPage.nextDirection
        self.moveTouchIndicator(toSide: touchIndicatorInitialSide)
        
        // screen content final position
        visibleScreenContentPage.setNext()
        screenContentImageView.setNeedsLayout()
        
        UIView.animateKeyframesWithDuration(3.0, delay: 0.0, options: [], animations: {
            
            // touch down
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0, animations: {
                self.touchIndicator.touchDown()
            })
            
            // swipe
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.4, animations: {
                self.moveTouchIndicator(toSide: touchIndicatorInitialSide.opposite)
            })
            
            // move screen content
            UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.3, animations: {
                self.screenContentImageView.layoutIfNeeded()
            })
            
            // touch up
            UIView.addKeyframeWithRelativeStartTime(0.85, relativeDuration: 0.05, animations: {
                self.touchIndicator.touchUp()
            })
            
            }, completion: { [weak self] _ in
            guard let `self` = self else { return }
            self.startAnimation()
        })
    }
    
    func stopAnimation() {
        screenContentImageView.layer.removeAllAnimations()
        touchIndicator.layer.removeAllAnimations()
        touchIndicator.touchUp()
    }
    
    func moveTouchIndicator(toSide side: Side) {
        switch side {
        case .Left:
            self.touchIndicator.frame.origin = CGPoint(x: self.touchIndicatorToPhoneOffsetX, y: self.touchIndicatorToPhoneOffsetY)
        case .Right:
            self.touchIndicator.frame.origin = CGPoint(x: self.phoneImageView.bounds.width - self.touchIndicator.bounds.width - self.touchIndicatorToPhoneOffsetX, y: self.touchIndicatorToPhoneOffsetY)
        }
    }
    
    func configureCustomConstraints() {
        screenContentImageView.snp_makeConstraints { make in
            screenContentLeadingConstraint = make.leading.equalTo(phoneImageView).offset(firstPageContentToPhoneHorizontalOffset).constraint
            make.top.equalTo(phoneImageView).offset(contentToPhoneVerticalOffset)
        }
        
        phoneImageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
