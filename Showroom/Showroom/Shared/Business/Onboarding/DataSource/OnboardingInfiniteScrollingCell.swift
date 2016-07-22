import UIKit
import SnapKit

class OnboardingInfiniteScrollingCell: UICollectionViewCell {
    private let animationTopOffset: CGFloat
    private let label = UILabel()
    private let animation = OnboardingInfiniteScrollingAnimation()
    
    private var animating: Bool {
        get { return animation.animating }
        set { animation.animating = newValue }
    }
    
    override init(frame: CGRect) {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            animationTopOffset = 160.0
            
        case .iPhone5, .iPhone6, .iPhone6Plus:
            fallthrough
        default:
            animationTopOffset = 193.0
        }
        
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor(named: .White)
        
        label.text = tr(.OnboardingInfiniteScrollingLabel)
        label.font = UIFont(fontType: .Onboarding)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        contentView.addSubview(label)
        contentView.addSubview(animation)
        
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
            make.top.equalToSuperview().offset(Dimensions.onboardingTopOffset)
            make.leading.equalToSuperview().offset(Dimensions.onboardingTextHorizontalOffset)
            make.trailing.equalToSuperview().offset(-Dimensions.onboardingTextHorizontalOffset)
            make.bottom.lessThanOrEqualTo(animation.snp_top)
        }
        
        animation.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(animationTopOffset)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}