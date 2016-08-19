import UIKit

protocol InitialOnboardingNotificationsCellDelegate: class {
    func onboardingNotificationDidTapAskMe(cell: InitialOnboardingNotificationsCell)
    func onboardingNotificationDidTapSkip(cell: InitialOnboardingNotificationsCell)
}

class InitialOnboardingNotificationsCell: UICollectionViewCell {
    private let label = UILabel()
    private let freeSpaceContentView = UIView()
    private let imageView: UIImageView
    private let askMeButton = UIButton()
    private let skipButton = UIButton()
    
    weak var delegate: InitialOnboardingNotificationsCellDelegate?
    
    override init(frame: CGRect) {
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            imageView = UIImageView(image: UIImage(asset: .Onb_push_4))
        case .iPhone5:
            imageView = UIImageView(image: UIImage(asset: .Onb_push))
        case .iPhone6:
            imageView = UIImageView(image: UIImage(asset: .Onb_push_6))
        case .iPhone6Plus:
            imageView = UIImageView(image: UIImage(asset: .Onb_push_6p))
        case .Unknown:
            imageView = UIImageView(image: UIImage(asset: .Onb_push_6))
        }
        
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor(named: .White)
        
        label.text = tr(.OnboardingNotificationsLabel)
        label.font = UIFont(fontType: .Onboarding)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        askMeButton.title = tr(.OnboardingNotificationsAskMe)
        askMeButton.applyBlueStyle()
        askMeButton.addTarget(self, action: #selector(InitialOnboardingNotificationsCell.didTapAskMe), forControlEvents: .TouchUpInside)
        
        skipButton.title = tr(.OnboardingNotificationsSkip)
        skipButton.applyPlainStyle()
        skipButton.addTarget(self, action: #selector(InitialOnboardingNotificationsCell.didTapSkip), forControlEvents: .TouchUpInside)
        
        freeSpaceContentView.addSubview(imageView)
        freeSpaceContentView.addSubview(askMeButton)
        
        addSubview(label)
        addSubview(freeSpaceContentView)
        addSubview(skipButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAskMe() {
        delegate?.onboardingNotificationDidTapAskMe(self)
    }
    
    func didTapSkip() {
        delegate?.onboardingNotificationDidTapSkip(self)
    }
    
    private func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.onboardingTopOffset)
            make.leading.equalToSuperview().offset(Dimensions.onboardingTextHorizontalOffset)
            make.trailing.equalToSuperview().offset(-Dimensions.onboardingTextHorizontalOffset)
        }
        
        freeSpaceContentView.snp_makeConstraints { make in
            make.top.equalTo(label.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(skipButton.snp_top)
        }
        
        imageView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        askMeButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(184)
            make.height.equalTo(46)
        }
        
        skipButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-22)
        }
    }
}

