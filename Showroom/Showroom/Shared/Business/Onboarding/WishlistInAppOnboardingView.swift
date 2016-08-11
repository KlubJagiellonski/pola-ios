import UIKit

protocol WishlistInAppOnboardingViewDelegate: class {
    func wishlistOnboardingViewDidTapDismissButton(view: WishlistInAppOnboardingView)
}

class WishlistInAppOnboardingView: UIView {
    private let labelTopOffset: CGFloat
    private let animationTopOffset: CGFloat
    
    weak var delegate: WishlistInAppOnboardingViewDelegate?    
    
    private let separator = UIView()
    private let closeButton = UIButton()
    
    private let label = UILabel()
    
    private let animation = OnboardingDoubleTapAnimation()
    
    var animating: Bool {
        get { return animation.animating }
        set { animation.animating = newValue }
    }
    
    init() {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            labelTopOffset = 16.0
            animationTopOffset = 67.0
        case .iPhone5:
            labelTopOffset = 27.0
            animationTopOffset = 85.0
        case .iPhone6:
            labelTopOffset = 38.0
            animationTopOffset = 119.0
        case .iPhone6Plus:
            labelTopOffset = 27.0
            animationTopOffset = 110.0
        default:
            labelTopOffset = 38.0
            animationTopOffset = 119.0
        }
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        separator.backgroundColor = UIColor(named: .Black)
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.addTarget(self, action: #selector(WishlistInAppOnboardingView.didTapDismissButton), forControlEvents: .TouchUpInside)
        
        label.text = tr(.OnboardingDoubleTapLabel)
        label.font = UIFont.latoRegular(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        addSubview(separator)
        addSubview(closeButton)
        addSubview(label)
        addSubview(animation)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        animating = newWindow != nil
    }
    
    func configureCustomConstraints() {
        separator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        closeButton.snp_makeConstraints { make in
            make.top.equalTo(separator.snp_bottom).offset(15.0)
            make.leading.equalToSuperview().offset(16.0)
        }
        
        label.snp_makeConstraints { make in
            make.top.equalTo(separator.snp_bottom).offset(labelTopOffset)
            make.leading.equalToSuperview().offset(43.0)
            make.trailing.equalToSuperview().offset(-43.0)
        }
        
        animation.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(animationTopOffset)
        }
    }
    
    func didTapDismissButton() {
        delegate?.wishlistOnboardingViewDidTapDismissButton(self)
    }
}