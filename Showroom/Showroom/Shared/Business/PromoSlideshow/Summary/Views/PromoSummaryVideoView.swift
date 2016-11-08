import Foundation
import UIKit

final class PromoSummaryVideoView: UIView, ViewSwitcherDataSource, ViewSwitcherDelegate {
    weak var playerView: PromoSummaryPlayerView?
    
    private let viewSwitcher: ViewSwitcher
    private let imageView = UIImageView()
    private let gradientView = GradientView()
    private let textContainerView = PromoSummaryVideoTextContainerView()
    private var separatorView: UIView?
    private var repeatButton: UIButton?
    
    init(caption: PromoSlideshowPlaylistItemCaption, withRepeatButton: Bool) {
        self.viewSwitcher = ViewSwitcher(successView: imageView)
        
        super.init(frame: CGRectZero)
        
        viewSwitcher.switcherDelegate = self
        viewSwitcher.switcherDataSource = self
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        gradientView.gradient.colors = caption.color.gradientColors()

        textContainerView.nextMovieLabel.textColor = caption.color.color()
        textContainerView.titleLabel.textColor = caption.color.color()
        textContainerView.subtitleLabel.textColor = caption.color.color()
        textContainerView.nextMovieLabel.text = tr(.PromoVideoSummaryNextMovie)
        textContainerView.titleLabel.text = caption.title
        textContainerView.subtitleLabel.text = caption.subtitle
        
        addSubview(viewSwitcher)
        addSubview(gradientView)
        addSubview(textContainerView)        
        
        if withRepeatButton {
            let separatorView = UIView()
            separatorView.backgroundColor = caption.color.color()
            
            let repeatButton = UIButton()
            repeatButton.addTarget(self, action: #selector(PromoSummaryVideoView.didTapRepeatButton), forControlEvents: .TouchUpInside)
            repeatButton.setTitle(tr(.PromoVideoSummaryRepeat), forState: .Normal)
            switch caption.color {
            case .Black:
                repeatButton.applyBlackPlainBoldStyle()
                repeatButton.setImage(UIImage(asset: .Repeat), forState: .Normal)
            case .White:
                repeatButton.applyWhitePlainBoldStyle()
                repeatButton.setImage(UIImage(asset: .Repeat_white), forState: .Normal)
            }
            
            addSubview(separatorView)
            addSubview(repeatButton)
            self.separatorView = separatorView
            self.repeatButton = repeatButton
        }
        
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
    
    func didTapRepeatButton() {
        playerView?.didTapRepeatButton()
    }
    
    private func configureCustomConstraints() {
        viewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            if repeatButton != nil {
                make.height.equalTo(310)
            } else {
                make.height.equalTo(144)
            }
        }
        
        textContainerView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            if let separatorView = separatorView {
                make.bottom.equalTo(separatorView.snp_top)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        separatorView?.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.boldSeparatorThickness)
            if let repeatButton = repeatButton {
                make.bottom.equalTo(repeatButton.snp_top)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        repeatButton?.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.currentDevice().screenType == .iPhone4 ? 40 : 46)
            make.bottom.equalToSuperview()
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

private class GradientView: UIView {
    private let gradient = CAGradientLayer()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        layer.addSublayer(gradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
    }
}

private class PromoSummaryVideoTextContainerView: UIView {
    private let nextMovieLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        nextMovieLabel.font = UIFont(fontType: .Normal)
        nextMovieLabel.textAlignment = .Center
        nextMovieLabel.numberOfLines = 1        
        
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 2
        
        subtitleLabel.font = UIFont(fontType: .Italic)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        addSubview(nextMovieLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        nextMovieLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalTo(titleLabel.snp_top).offset(-2)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(subtitleLabel)
            make.trailing.equalTo(subtitleLabel)
            make.bottom.equalTo(subtitleLabel.snp_top)
        }
        
        subtitleLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
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

