import UIKit
import SnapKit

class OnboardingInfiniteScrollingCell: UICollectionViewCell {
    private let labelHorizontalInset: CGFloat = 22.0
    private let scrollAnimationInterval = 6.0
    
    private let logoToPhoneImageOffset: CGFloat
    private let labelToPhoneImageOffset: CGFloat
    
    private let label = UILabel()
    private let phoneImageView: UIImageView
    private let logoImageView: UIImageView
    
    private let firstClothesView: UIImageView
    private let secondClothesView: UIImageView
    
    private var animating = false {
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
            labelToPhoneImageOffset = 160.0
            
        case .iPhone5:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_5))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_5))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_5))
            logoToPhoneImageOffset = 54.4
            labelToPhoneImageOffset = 193.0
            
        case .iPhone6:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6))
            logoToPhoneImageOffset = 80.2
            labelToPhoneImageOffset = 193.0
            
        case .iPhone6Plus:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6p))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6p))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6p))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6p))
            logoToPhoneImageOffset = 87.1
            labelToPhoneImageOffset = 193.0
            
        default:
            firstClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            secondClothesView = UIImageView(image: UIImage(asset: .Onb_img1_6))
            phoneImageView = UIImageView(image: UIImage(asset: .Onb_iphone_6))
            logoImageView = UIImageView(image: UIImage(asset: .Onb_logo_6))
            logoToPhoneImageOffset = 80.2
            labelToPhoneImageOffset = 193.0
        }

        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor(named: .White)
        
        label.text = tr(.OnboardingInfiniteScrollingLabel)
        label.font = UIFont(fontType: .Onboarding)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        contentView.addSubview(label)
        contentView.addSubview(phoneImageView)
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
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(62.0)
            make.leading.equalToSuperview().offset(labelHorizontalInset)
            make.trailing.equalToSuperview().offset(-labelHorizontalInset)
            make.bottom.lessThanOrEqualTo(phoneImageView.snp_top)
        }
        
        phoneImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(labelToPhoneImageOffset)
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
        let clothesView = contentView.subviews.contains(secondClothesView) ? firstClothesView : secondClothesView
        contentView.addSubview(clothesView)
        contentView.bringSubviewToFront(phoneImageView)
        
        var leadingConstraint: Constraint!
        
        clothesView.snp_makeConstraints { make in
            make.bottom.equalTo(phoneImageView)
            leadingConstraint = make.leading.equalTo(contentView.snp_trailing).constraint
        }
        layoutIfNeeded()
        
        // scroll clothesView till clothesView.leading == superview.leading
        leadingConstraint.updateOffset(-clothesView.bounds.width)
        contentView.setNeedsLayout()
        
        UIView.animateWithDuration(scrollAnimationInterval, delay: 0.0, options: [.CurveLinear], animations: { [unowned self] _ in
            self.contentView.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }

                // scroll clothesView till clothesView.trailing == superview.leading
                leadingConstraint.updateOffset(-clothesView.bounds.width - self.bounds.width)                
                
                let completingScrollDuration = (self.scrollAnimationInterval) * Double(self.contentView.bounds.width) / Double(clothesView.bounds.width)
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