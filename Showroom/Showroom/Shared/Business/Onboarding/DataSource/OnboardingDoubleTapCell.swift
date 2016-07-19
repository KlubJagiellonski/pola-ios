import UIKit

class OnboardingDoubleTapCell: UICollectionViewCell {
    private let animationTopOffset: CGFloat = 157.2
    private let label = UILabel()
    private let animation = OnboardingDoubleTapAnimation()
    
    var animating: Bool {
        get { return animation.animating }
        set { animation.animating = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor(named: .White)
        contentView.clipsToBounds = true
        
        label.text = tr(.OnboardingDoubleTapLabel)
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
        }
        
        animation.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(animationTopOffset)
        }
    }
}