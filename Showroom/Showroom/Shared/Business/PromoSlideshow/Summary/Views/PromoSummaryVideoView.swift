import Foundation
import UIKit

final class PromoSummaryVideoView: UIView, ViewSwitcherDataSource, ViewSwitcherDelegate {
    weak var playerView: PromoSummaryPlayerView?
    
    private let viewSwitcher: ViewSwitcher
    private let imageView = UIImageView()
    private let textContainerView = PromoSummaryVideoTextContainerView()
    
    init(caption: PromoSlideshowPlaylistItemCaption) {
        self.viewSwitcher = ViewSwitcher(successView: imageView)
        
        super.init(frame: CGRectZero)
        
        viewSwitcher.switcherDelegate = self
        viewSwitcher.switcherDataSource = self
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        textContainerView.backgroundGradient.colors = caption.color.gradientColors()
        textContainerView.titleLabel.textColor = caption.color.color()
        textContainerView.subtitleLabel.textColor = caption.color.color()
        textContainerView.titleLabel.text = caption.title
        textContainerView.subtitleLabel.text = caption.subtitle
        
        addSubview(viewSwitcher)
        addSubview(textContainerView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withImageUrl imageUrl: String, width: CGFloat, retrievedFromCacheResult: Bool -> Void, success: Void -> Void) {
        let retrievedFromCache = { [weak self] (image: UIImage?) in
            guard let `self` = self else { return }
            if image != nil {
                self.imageView.image = image
                self.viewSwitcher.changeSwitcherState(.Success, animated: false)
            }
            retrievedFromCacheResult(image != nil)
        }
        
        let failure = { [weak self] (error: NSError?) in
            guard let `self` = self else { return }
            logInfo("Error while downloading image \(error)")
            self.viewSwitcher.changeSwitcherState(.Error, animated: true)
        }
        
        let success = { [weak self] (image: UIImage) in
            guard let `self` = self else { return }
            self.imageView.image = image
            self.viewSwitcher.changeSwitcherState(.Success, animated: true)
            success()
        }
        
        imageView.loadImageFromUrl(imageUrl, width: width, onRetrievedFromCache: retrievedFromCache, failure: failure, success: success)
    }
    
    private func configureCustomConstraints() {
        viewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textContainerView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(144)
        }
    }
    
    // MARK:- ViewSwitcherDataSource
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return PromoSummaryVideoErrorView()
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    // MARK:- ViewSwitcherDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        viewSwitcher.changeSwitcherState(.Loading)
        playerView?.didTapRetryImageDownload(with: self)
    }
}

private class PromoSummaryVideoErrorView: UIView, ErrorViewInterface {
    weak var viewSwitcher: ViewSwitcher?
    private var containerType: ViewSwitcherContainerType = .Normal
    
    private let retryButton = UIButton()
    
    init() {
        super.init(frame: CGRectZero)
        
        retryButton.applyBigCircleStyle()
        retryButton.setImage(UIImage(asset: .Refresh), forState: .Normal)
        retryButton.addTarget(self, action: #selector(PromoSummaryVideoErrorView.didTapRetry), forControlEvents: .TouchUpInside)
        
        addSubview(retryButton)
        
        retryButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Dimensions.bigCircleButtonDiameter)
            make.height.equalTo(retryButton.snp_width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapRetry() {
        guard let viewSwitcher = viewSwitcher else { return }
        viewSwitcher.switcherDelegate?.viewSwitcherDidTapRetry(viewSwitcher)
    }
}

private class PromoSummaryVideoTextContainerView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let backgroundGradient = CAGradientLayer()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        layer.addSublayer(backgroundGradient)
        
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 2
        
        subtitleLabel.font = UIFont(fontType: .Italic)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
    }
    
    private func configureCustomConstraints() {
        subtitleLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(subtitleLabel)
            make.trailing.equalTo(subtitleLabel)
            make.bottom.equalTo(subtitleLabel.snp_top)
        }
    }
}

extension PromoSlideshowPlaylistItemCaptionColor {
    func gradientColors() -> [CGColor] {
        switch self {
        case .Black:
            return [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor]
        case .White:
            return [UIColor.blackColor().colorWithAlphaComponent(0).CGColor, UIColor.blackColor().CGColor]
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .Black:
            return UIColor.blackColor()
        case .White:
            return UIColor.whiteColor()
        }
    }
}

