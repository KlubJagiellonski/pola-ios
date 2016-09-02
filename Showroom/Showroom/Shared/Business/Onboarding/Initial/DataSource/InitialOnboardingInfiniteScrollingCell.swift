import UIKit
import SnapKit

protocol InitialOnboardingInfiniteScrollingCellDelegate: class {
    func onboardingInfiniteScrollingDidTapNext(cell: InitialOnboardingInfiniteScrollingCell)
}

class InitialOnboardingInfiniteScrollingCell: UICollectionViewCell {
    private let animationTopOffset: CGFloat
    private let buttonBottomOffset: CGFloat
    private let buttonHeight: CGFloat = 46.0
    private let buttonWidth: CGFloat = 147.0
    
    private let label = UILabel()
    private let animation = OnboardingInfiniteScrollingAnimation()
    private let nextButton = UIButton()
    
    private var animating: Bool {
        get { return animation.animating }
        set { animation.animating = newValue }
    }
    
    weak var delegate: InitialOnboardingInfiniteScrollingCellDelegate?
    
    override init(frame: CGRect) {
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            animationTopOffset = 130.0
            buttonBottomOffset = 30.0
            
        case .iPhone5:
            animationTopOffset = 150.0
            buttonBottomOffset = 50.0
            
        case .iPhone6:
            animationTopOffset = 150.0
            buttonBottomOffset = 55.0
            
        case .iPhone6Plus:
            animationTopOffset = 160.0
            buttonBottomOffset = 65.0
            
        default:
            animationTopOffset = 150.0
            buttonBottomOffset = 55.0
        }
        
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor(named: .White)
        
        let boldedText = tr(.OnboardingInfiniteScrollingLabelBoldPart)
        label.font = UIFont(fontType: .Onboarding)
        label.attributedText = tr(.OnboardingInfiniteScrollingLabel(boldedText)).stringWithOtherFontSubstring(boldedText, font: UIFont.latoBold(ofSize: 16))
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        nextButton.applyBlueStyle()
        nextButton.title = tr(.OnboardingInfiniteScrollingNext)
        nextButton.addTarget(self, action: #selector(InitialOnboardingInfiniteScrollingCell.didTapNext), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(label)
        contentView.addSubview(animation)
        contentView.addSubview(nextButton)
        
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
    
    func didTapNext(sender: UIButton!) {
        delegate?.onboardingInfiniteScrollingDidTapNext(self)
    }
    
    func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.statusBarHeight)
            make.leading.equalToSuperview().offset(Dimensions.onboardingTextHorizontalOffset)
            make.trailing.equalToSuperview().offset(-Dimensions.onboardingTextHorizontalOffset)
            make.bottom.equalTo(animation.snp_top)
        }
        
        animation.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(animationTopOffset)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        nextButton.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-buttonBottomOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonWidth)
        }
    }
}