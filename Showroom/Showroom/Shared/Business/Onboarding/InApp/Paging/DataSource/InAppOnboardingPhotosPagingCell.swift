import UIKit

protocol InAppOnboardingPhotosPagingCellDelegate: class {
    func onboardingPhotoPagingCellDidTapNext(cell: InAppOnboardingPhotosPagingCell)
}

class InAppOnboardingPhotosPagingCell: UICollectionViewCell {
    private let labelTopOffset: CGFloat
    private let buttonTopOffset: CGFloat
    private let animationTopOffset: CGFloat
    
    private let separator = UIView()
    private let label = UILabel()
    private let nextButton = UIButton()
    private let animation = OnboardingPhotosPagingAnimation()
    
    weak var delegate: InAppOnboardingPhotosPagingCellDelegate?
    
    override init(frame: CGRect) {
        
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
        
        label.text = tr(.OnboardingPhotosPagingLabel)
        label.font = UIFont.latoRegular(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        nextButton.applyPlainStyle()
        nextButton.title = tr(.OnboardingPhotosPagingNext)
        nextButton.addTarget(self, action: #selector(InAppOnboardingPhotosPagingCell.didTapNext), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(separator)
        contentView.addSubview(label)
        contentView.addSubview(nextButton)
        contentView.addSubview(animation)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        logInfo("startAnimation")
        animation.animating = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InAppOnboardingPhotosPagingCell.didReceiveApplicationDidBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InAppOnboardingPhotosPagingCell.didReceiveApplicationWillResignActive), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func stopAnimation() {
        logInfo("stopAnimation")
        animation.animating = false
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didTapNext(sender: UIButton!) {
        logInfo("photos paging did tap next")
        delegate?.onboardingPhotoPagingCellDidTapNext(self)
    }
    
    @objc private func didReceiveApplicationWillResignActive() {
        animation.animating = false
    }
    
    @objc private func didReceiveApplicationDidBecomeActive() {
        animation.animating = true
    }
    
    private func configureCustomConstraints() {
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
        
        nextButton.snp_makeConstraints { make in
            make.top.equalTo(label.snp_bottom).offset(buttonTopOffset)
            make.centerX.equalToSuperview()
        }
        
        animation.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp_bottom).offset(animationTopOffset)
        }
    }
}