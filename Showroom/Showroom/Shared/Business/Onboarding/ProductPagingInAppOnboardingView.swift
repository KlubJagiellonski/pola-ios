import UIKit

protocol ProductPagingInAppOnboardingViewDelegate: class {
    func productPagingOnboardingViewDidTapDismissButton(view: ProductPagingInAppOnboardingView)
}

class ProductPagingInAppOnboardingView: UIView {
    private let labelTopOffset: CGFloat
    private let labelHorizontalInset: CGFloat
    private let animationTopOffset: CGFloat
    
    weak var delegate: ProductPagingInAppOnboardingViewDelegate?
    
    private let separator = UIView()
    private let closeButton = UIButton()
    
    private let label = UILabel()
    
    private let animation = OnboardingProductPagingAnimation()
    
    var animating: Bool {
        get { return animation.animating }
        set { animation.animating = newValue }
    }
    
    init() {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            labelTopOffset = 16.5
            labelHorizontalInset = 39.0
            animationTopOffset = 70.0
        case .iPhone5:
            labelTopOffset = 27.0
            labelHorizontalInset = 39.0
            animationTopOffset = 85.0
        case .iPhone6:
            labelTopOffset = 38.0
            labelHorizontalInset = 61.0
            animationTopOffset = 119.0
        case .iPhone6Plus:
            labelTopOffset = 27.0
            labelHorizontalInset = 52.0
            animationTopOffset = 111.0
        default:
            labelTopOffset = 38.0
            labelHorizontalInset = 61.0
            animationTopOffset = 119.0
        }
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        separator.backgroundColor = UIColor(named: .Black)
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.addTarget(self, action: #selector(ProductPagingInAppOnboardingView.didTapDismissButton), forControlEvents: .TouchUpInside)
        
        label.text = tr(.OnboardingProductPagingLabel)
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
            make.leading.equalToSuperview().offset(labelHorizontalInset)
            make.trailing.equalToSuperview().offset(-labelHorizontalInset)
        }
        
        animation.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator.snp_bottom).offset(animationTopOffset)
        }
    }
    
    func didTapDismissButton() {
        delegate?.productPagingOnboardingViewDidTapDismissButton(self)
    }
}