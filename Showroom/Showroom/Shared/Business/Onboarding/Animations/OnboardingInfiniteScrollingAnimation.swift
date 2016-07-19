import UIKit
import SnapKit

class OnboardingInfiniteScrollingAnimation: UIView {
    private let scrollAnimationInterval = 10.0
    
    private let logoToPhoneImageOffset: CGFloat
    
    private let phoneImageView: UIImageView
    private let logoImageView: UIImageView
    
    private let firstClothesView: UIImageView
    private let secondClothesView: UIImageView
    
    var animating = false {
        didSet {
            if animating {
                beginScrollingAnimation()
            } else {
                firstClothesView.layer.removeAllAnimations()
                secondClothesView.layer.removeAllAnimations()
                firstClothesView.removeFromSuperview()
                secondClothesView.removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_5))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_5))
            logoToPhoneImageOffset = 54.4
            
        case .iPhone5:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_5))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_5))
            logoToPhoneImageOffset = 54.4
            
        case .iPhone6:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6))
            logoToPhoneImageOffset = 80.2
            
        case .iPhone6Plus:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6p))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6p))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6p))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6p))
            logoToPhoneImageOffset = 87.1
            
        default:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6))
            logoToPhoneImageOffset = 80.2
        }
        
        super.init(frame: CGRectZero)
        
        addSubview(phoneImageView)
        phoneImageView.addSubview(logoImageView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if newWindow == nil {
            animating = false
        } else {
            animating = true
        }
    }
    
    func configureCustomConstraints() {
        phoneImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(logoToPhoneImageOffset)
            make.centerX.equalToSuperview()
        }
    }
    
    func beginScrollingAnimation() {
        guard animating else { return }
        
        // add clothes subview
        let clothesView = subviews.contains(secondClothesView) ? firstClothesView : secondClothesView
        addSubview(clothesView)
        bringSubviewToFront(phoneImageView)
        
        var leadingConstraint: Constraint!
        
        clothesView.snp_makeConstraints { make in
            make.bottom.equalTo(phoneImageView)
            leadingConstraint = make.leading.equalTo(self.snp_trailing).constraint
        }
        layoutIfNeeded()
        
        // scroll clothesView till clothesView.leading == superview.leading
        leadingConstraint.updateOffset(-clothesView.bounds.width)
        setNeedsLayout()
        
        UIView.animateWithDuration(scrollAnimationInterval, delay: 0.0, options: [.CurveLinear], animations: { [unowned self] _ in
            self.layoutIfNeeded()
            }, completion: { [weak self] _ in
            guard let `self` = self else { return }
            
            // scroll clothesView till clothesView.trailing == superview.leading
            leadingConstraint.updateOffset(-clothesView.bounds.width - self.bounds.width)
            
            let completingScrollDuration = (self.scrollAnimationInterval) * Double(self.bounds.width) / Double(clothesView.bounds.width)
            UIView.animateWithDuration(completingScrollDuration, delay: 0.0, options: [.CurveLinear], animations: { [unowned self] _ in
                self.layoutIfNeeded()
                }, completion: { _ in
                clothesView.removeFromSuperview()
            })
            
            // begin scrolling animation with new clothes subview
            self.beginScrollingAnimation()
        })
    }
}
