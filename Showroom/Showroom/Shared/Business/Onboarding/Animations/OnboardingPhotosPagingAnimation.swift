import Foundation
import UIKit
import SnapKit

enum VerticalSide {
    case Up, Down
    var opposite: VerticalSide { return (self == .Up) ? .Down : .Up }
}

enum PhotoPage {
    case First
    case Second(direction: VerticalSide)
    case Third
    
    var nextDirection: VerticalSide {
        switch self {
        case .First: return .Down
        case .Second(let direction): return direction
        case .Third: return .Up
        }
    }
    mutating func setNext() {
        switch self {
        case .First: self = .Second(direction: .Down)
        case .Second(direction: .Down): self = .Third
        case .Third: self = .Second(direction: .Up)
        case .Second(direction: .Up): self = .First
        }
    }
}

final class OnboardingPhotosPagingAnimation: UIView {
    private let firstPageContentToPhoneVerticalOffset: CGFloat
    private let contentToPhoneHorizontalOffset: CGFloat
    private let touchIndicatorToScreenOffsetY: CGFloat = 60.0
    
    private let phoneImageView: UIImageView
    private let screenContentMaskView = UIView()
    private let screenContentImageView: UIImageView
    
    private let touchIndicator = TouchIndicatorView()
    
    private var screenContentTopConstraint: Constraint!
    
    private var visibleScreenContentPage: PhotoPage {
        didSet {
            switch visibleScreenContentPage {
            case .First:
                screenContentTopConstraint.updateOffset(firstPageContentToPhoneVerticalOffset)
            case .Second:
                screenContentTopConstraint.updateOffset(firstPageContentToPhoneVerticalOffset - (screenContentImageView.bounds.height / 3))
            case .Third:
                screenContentTopConstraint.updateOffset(firstPageContentToPhoneVerticalOffset - (screenContentImageView.bounds.height * 2 / 3))
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
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_4_vert))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_4_4))
            firstPageContentToPhoneVerticalOffset = 56.0
            contentToPhoneHorizontalOffset = 11.0
            
        case .iPhone5:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_5_vert))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_4))
            firstPageContentToPhoneVerticalOffset = 67.0
            contentToPhoneHorizontalOffset = 15.0
            
        case .iPhone6:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6_vert))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_4_6))
            firstPageContentToPhoneVerticalOffset = 76.0
            contentToPhoneHorizontalOffset = 17.0
            
        case .iPhone6Plus:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6p_vert))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_4_6p))
            firstPageContentToPhoneVerticalOffset = 88.0
            contentToPhoneHorizontalOffset = 19.0
            
        default:
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_big_6_vert))
            screenContentImageView = UIImageView(image: UIImage(asset: .Onb_img_4_6))
            firstPageContentToPhoneVerticalOffset = 76.0
            contentToPhoneHorizontalOffset = 17.0
        }
        
        visibleScreenContentPage = .First
        
        super.init(frame: CGRectZero)
        
        moveTouchIndicator(toSide: visibleScreenContentPage.nextDirection)
        
        screenContentMaskView.clipsToBounds = true
        
        addSubview(screenContentMaskView)
        screenContentMaskView.addSubview(screenContentImageView)
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
            
            }, completion: { [weak self] success in
                guard let `self` = self where success else { return }
                self.startAnimation()
            })
    }
    
    func stopAnimation() {
        screenContentImageView.layer.removeAllAnimations()
        touchIndicator.layer.removeAllAnimations()
        touchIndicator.touchUp()
    }
    
    func moveTouchIndicator(toSide side: VerticalSide) {
        switch side {
        case .Up:
            self.touchIndicator.frame.origin = CGPoint(x: self.phoneImageView.bounds.midX - touchIndicator.bounds.midX, y: self.touchIndicatorToScreenOffsetY + self.firstPageContentToPhoneVerticalOffset)
        case .Down:
            self.touchIndicator.frame.origin = CGPoint(x: self.phoneImageView.bounds.midX - touchIndicator.bounds.midX, y: self.phoneImageView.bounds.maxY - self.touchIndicator.bounds.maxY - self.touchIndicatorToScreenOffsetY)

        }
    }
    
    func configureCustomConstraints() {
        screenContentMaskView.snp_makeConstraints { make in
            make.top.equalTo(phoneImageView).offset(50.0)
            make.bottom.equalTo(phoneImageView)
            make.leading.equalTo(phoneImageView).offset(2.0)
            make.trailing.equalTo(phoneImageView).offset(-2.0)
        }
        
        screenContentImageView.snp_makeConstraints { make in
            make.leading.equalTo(phoneImageView).offset(contentToPhoneHorizontalOffset)
            screenContentTopConstraint = make.top.equalTo(phoneImageView).offset(firstPageContentToPhoneVerticalOffset).constraint
        }
        
        phoneImageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
