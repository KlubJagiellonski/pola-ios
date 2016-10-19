import Foundation
import UIKit

private enum HudAnimationStep {
    case First, Second
}

final class PromoSummaryPlayerView: UIView {
    weak var promoSummaryView: PromoSummaryView?
    
    private let hudView = PromoSummaryPlayerHudView()
    private var currentVideoView: PromoSummaryVideoView {
        didSet {
            currentVideoView.playerView = self
        }
    }
    
    private let videos: [PromoSlideshowPlaylistItem]
    private var currentVideoIndex: Int
    private var firstLayoutSubviewsPassed = false
    private var shouldStartPlayAnimation = false
    
    init(playlistItems: [PromoSlideshowPlaylistItem]) {
        self.currentVideoIndex = playlistItems.count > 1 ? 1 : 0
        let video = playlistItems[currentVideoIndex]
        self.videos = playlistItems
        self.currentVideoView = PromoSummaryVideoView(caption: video.caption)
        super.init(frame: CGRectZero)
        
        self.currentVideoView.playerView = self
        
        backgroundColor = UIColor(named: .ProductPageBackground)
        
        hudView.hidden = self.videos.count < 2
        hudView.nextButton.alpha = (playlistItems.count - 1) == currentVideoIndex ? 0 : 1
        hudView.backButton.addTarget(self, action: #selector(PromoSummaryPlayerView.didTapBack), forControlEvents: .TouchUpInside)
        hudView.nextButton.addTarget(self, action: #selector(PromoSummaryPlayerView.didTapNext), forControlEvents: .TouchUpInside)
        hudView.playControl.addTarget(self, action: #selector(PromoSummaryPlayerView.didTapPlay), forControlEvents: .TouchUpInside)
        hudView.playControl.playerView = self
        hudView.playControl.enabled = false
        
        addSubview(currentVideoView)
        addSubview(hudView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !firstLayoutSubviewsPassed {
            updateVideoImageView()
            hudView.playControl.invalidateAndStartAnimation()
            firstLayoutSubviewsPassed = true
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        //it is because hud is above current video view. So when there was an error while retrieving image, without it it wouldn't be possible to hit retry
        if view == hudView {
            return currentVideoView.hitTest(point, withEvent: event)
        }
        return view
    }
    
    func startPlayAnimation() {
        hudView.playControl.enabled = true
        hudView.playControl.invalidateAndStartAnimation()
    }
    
    func stopPlayAnimation() {
        hudView.playControl.invalidate()
        hudView.playControl.enabled = false
    }
    
    func didTapRetryImageDownload(with view: PromoSummaryVideoView) {
        updateVideoImageView()
    }
    
    func didFinishedPlayControlAnimation(with view: PromoSummaryPlayControl) {
        promoSummaryView?.didAutoPlay(forVideo: videos[currentVideoIndex])
    }
    
    @objc private func didTapBack() {
        promoSummaryView?.didTapBack(withCurrentVideo: videos[currentVideoIndex])
        currentVideoIndex -= 1
        
        updateCurrentVideoView()
    }
    
    @objc private func didTapNext() {
        promoSummaryView?.didTapNext(withCurrentVideo: videos[currentVideoIndex])
        currentVideoIndex += 1
        
        updateCurrentVideoView()
    }
    
    @objc private func didTapPlay() {
        promoSummaryView?.didTap(playForVideo: videos[currentVideoIndex])
    }
    
    private func updateCurrentVideoView() {
        userInteractionEnabled = false
        
        let video = videos[currentVideoIndex]
        
        let currentVideoView = self.currentVideoView
        let newVideoView = PromoSummaryVideoView(caption: video.caption)
        addSubview(newVideoView)
        bringSubviewToFront(hudView)
        newVideoView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newVideoView.alpha = 0
        currentVideoView.alpha = 1
        
        var animationDidEnd = false
        var updateHudOnAnimationEnd = false
        
        let retrievedFromCacheResult: Bool -> Void = { (result: Bool) in
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5) { [unowned self] in
                    currentVideoView.alpha = 0
                    self.updateHud(forAnimationStep: .First, cachedImageExist: result)
                }
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5) { [unowned self] in
                    newVideoView.alpha = 1
                    self.updateHud(forAnimationStep: .Second, cachedImageExist: result)
                }
            }) { [weak self] _ in
                guard let `self` = self else { return }
                currentVideoView.removeFromSuperview()
                self.currentVideoView = newVideoView
                self.userInteractionEnabled = true
                animationDidEnd = true
                if updateHudOnAnimationEnd {
                    self.updateHud(true, animated: true)
                }
            }
        }
        
        newVideoView.update(withImageUrl: video.imageUrl, width: bounds.width, retrievedFromCacheResult: retrievedFromCacheResult) { [weak self] in
            guard let `self` = self else { return }
            if animationDidEnd {
                self.updateHud(true, animated: true)
            } else {
                updateHudOnAnimationEnd = true
            }
        }
    }
    
    private func updateVideoImageView() {
        let video = videos[currentVideoIndex]
       
        let retrievedFromCacheResult: Bool -> Void = { [weak self](result: Bool) in
            self?.updateHud(result, animated: true)
        }
        
        let success: Void -> Void = { [weak self] in
            self?.updateHud(true, animated: true)
        }
        
        currentVideoView.update(withImageUrl: video.imageUrl, width: bounds.width, retrievedFromCacheResult: retrievedFromCacheResult, success: success)
    }
    
    private func updateHud(showPlayButton: Bool, animated: Bool) {
        userInteractionEnabled = false
        
        UIView.animateWithDuration(animated ? 0.1 : 0) { [unowned self] in
            self.userInteractionEnabled = true
            self.hudView.playControl.alpha = showPlayButton ? 1 : 0
            if showPlayButton && !self.hudView.playControl.progressVisible {
                logInfo("updateHud, playButton")
                self.hudView.playControl.invalidateAndStartAnimation()
                self.hudView.playControl.progressVisible = true
            }
        }
    }
    
    private func updateHud(forAnimationStep step: HudAnimationStep, cachedImageExist: Bool) {
        
        let backVisibleForNewIndex = currentVideoIndex != 0
        let nextVisibleForNewIndex = currentVideoIndex != (videos.count - 1)
        
        switch step {
        case .First:
            logInfo("updateHud, first")
            self.hudView.playControl.progressVisible = false
            if !cachedImageExist {
                self.hudView.playControl.alpha = 0
            }
            if !backVisibleForNewIndex {
                self.hudView.backButton.alpha = 0
            }
            if !nextVisibleForNewIndex {
                self.hudView.nextButton.alpha = 0
            }
        case .Second:
            if cachedImageExist {
                logInfo("updateHud, second")
                self.hudView.playControl.alpha = 1
                self.hudView.playControl.invalidateAndStartAnimation()
                self.hudView.playControl.progressVisible = true
            }
            if backVisibleForNewIndex {
                self.hudView.backButton.alpha = 1
            }
            if nextVisibleForNewIndex {
                self.hudView.nextButton.alpha = 1
            }
        }
    }

    private func configureCustomConstraints() {
        currentVideoView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hudView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

final class PromoSummaryPlayerHudView: UIView {
    private let buttonSpacing: CGFloat = 40
    
    private let backButton = UIButton()
    private let playControl = PromoSummaryPlayControl()
    private let nextButton = UIButton()
    
    init() {
        super.init(frame: CGRectZero)
        
        backButton.applyMediaControlStyle()
        backButton.setImage(UIImage(asset: .Previous), forState: .Normal)
        
        nextButton.applyMediaControlStyle()
        nextButton.setImage(UIImage(asset: .Next), forState: .Normal)
        
        addSubview(backButton)
        addSubview(playControl)
        addSubview(nextButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        playControl.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(Dimensions.mediaPlayButtonDiameter)
            make.height.equalTo(playControl.snp_width)
        }
        
        backButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(playControl.snp_leading).offset(-buttonSpacing)
            make.width.equalTo(Dimensions.mediaControlButtonDiameter)
            make.height.equalTo(backButton.snp_width)
        }
        
        nextButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playControl.snp_trailing).offset(buttonSpacing)
            make.width.equalTo(Dimensions.mediaControlButtonDiameter)
            make.height.equalTo(backButton.snp_width)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let width = 2 * Dimensions.mediaControlButtonDiameter + Dimensions.mediaPlayButtonDiameter + 2 * buttonSpacing
        return CGSize(width: width, height: Dimensions.mediaPlayButtonDiameter)
    }
}