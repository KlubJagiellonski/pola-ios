import UIKit

protocol WishlistInAppOnboardingViewDelegate: class {
    func wishlistOnboardingViewDidTapDismissButton(view: WishlistInAppOnboardingView)
}

class WishlistInAppOnboardingView: UIView {
    private let labelTopOffset: CGFloat
    private let buttonTopOffset: CGFloat
    private let animationTopOffset: CGFloat
    
    private let separator = UIView()
    private let label = UILabel()
    private let dismissButton = UIButton()
    private let animation = OnboardingDoubleTapAnimation()
    
    weak var delegate: WishlistInAppOnboardingViewDelegate?
    
    init() {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            labelTopOffset = 9.0
            buttonTopOffset = 7.0
            animationTopOffset = 11.0
        case .iPhone5:
            labelTopOffset = 9.0
            buttonTopOffset = 11.0
            animationTopOffset = 13.0
        case .iPhone6:
            labelTopOffset = 17.0
            buttonTopOffset = 18.0
            animationTopOffset = 30.0
        case .iPhone6Plus:
            labelTopOffset = 20.0
            buttonTopOffset = 17.0
            animationTopOffset = 20.0
        default:
            labelTopOffset = 17.0
            buttonTopOffset = 18.0
            animationTopOffset = 30.0
        }
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        separator.backgroundColor = UIColor(named: .Black)
        
        label.text = tr(.OnboardingDoubleTapLabel)
        label.font = UIFont.latoRegular(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        dismissButton.applyPlainStyle()
        dismissButton.title = tr(.OnboardingProductPagingDismiss)
        dismissButton.addTarget(self, action: #selector(WishlistInAppOnboardingView.didTapDismissButton), forControlEvents: .TouchUpInside)
        
        addSubview(separator)
        addSubview(dismissButton)
        addSubview(label)
        addSubview(animation)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        logInfo("willMoveToWindow: \(newWindow)")
        if newWindow != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WishlistInAppOnboardingView.startAnimation), name: UIApplicationDidBecomeActiveNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WishlistInAppOnboardingView.stopAnimation), name: UIApplicationWillResignActiveNotification, object: nil)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        animation.animating = newWindow != nil
    }
    
    func startAnimation() {
        logInfo("startAnimation")
        animation.animating = true
    }
    
    func stopAnimation() {
        logInfo("stopAnimation")
        animation.animating = false
    }
    
    func configureCustomConstraints() {
        separator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        label.snp_makeConstraints { make in
            make.top.equalTo(separator.snp_bottom).offset(labelTopOffset)
            make.leading.equalToSuperview().offset(Dimensions.onboardingTextHorizontalOffset)
            make.trailing.equalToSuperview().offset(-Dimensions.onboardingTextHorizontalOffset)
        }
        
        dismissButton.snp_makeConstraints { make in
            make.top.equalTo(label.snp_bottom).offset(buttonTopOffset)
            make.centerX.equalToSuperview()
        }
        
        animation.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dismissButton.snp_bottom).offset(animationTopOffset)
        }
    }
    
    func didTapDismissButton() {
        delegate?.wishlistOnboardingViewDidTapDismissButton(self)
    }
}