import Foundation
import UIKit
import SnapKit

protocol ProductImageVideoCellDelegate: class {
    func productImageVideoCellDidFinishVideo(cell: ProductImageVideoCell)
    func productImageVideoCellDidLoadVideo(cell: ProductImageVideoCell, asset: AVAsset)
    func productImageVideoCellFailedToLoadVideo(cell: ProductImageVideoCell)
}

final class ProductImageVideoCell: UICollectionViewCell, ProductImageCellInterface, VIMVideoPlayerViewDelegate {
    private let contentViewSwitcher: ViewSwitcher
    private let successContentView = UIView()
    private var playerView: VIMVideoPlayerView?
    private let previewView = ProductImageVideoPreviewView()
    
    private var currentVideo: ProductDetailsVideo?
    private var currentVideoAssetFactory: (Void -> AVAsset)?
    var fullScreenMode = false {
        didSet {
            configureContentInsets()
            guard fullScreenMode != oldValue else { return }
            configureViewsForCurrentFullScreenMode()
        }
    }
    var screenInset: UIEdgeInsets?
    var fullScreenInset: UIEdgeInsets?
    private var lastVideoLoadedDuration: Double?
    weak var delegate: ProductImageVideoCellDelegate?
    
    override init(frame: CGRect) {
        contentViewSwitcher = ViewSwitcher(successView: successContentView)
        super.init(frame: frame)
        
        successContentView.addSubview(previewView)
        
        contentViewSwitcher.switcherDelegate = self
        contentViewSwitcher.switcherDataSource = self
        
        contentView.addSubview(contentViewSwitcher)
        
        configureCustomConstraints()
        configureViewsForCurrentFullScreenMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with video: ProductDetailsVideo, assetFactory: Void -> AVAsset) {
        self.currentVideo = video
        self.currentVideoAssetFactory = assetFactory
        configureForCurrentVideo()
    }
    
    func didEndDisplaying() {
        playerView?.player.reset()
    }
    
    private func configureForCurrentVideo() {
        configurePreviewView(animated: false)
        configurePlayerView(animated: false)
    }
    
    private func configureCustomConstraints() {
        contentViewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        previewView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureViewsForCurrentFullScreenMode() {
        if fullScreenMode {
            self.playerView?.removeFromSuperview()
            
            let playerView = VIMVideoPlayerView(frame: bounds)
            playerView.delegate = self
            successContentView.insertSubview(playerView, atIndex: 0)
            self.playerView = playerView
            
            playerView.snp_makeConstraints { make in make.edges.equalToSuperview() }
            
            configurePlayerView(animated: false)
        } else {
            self.previewView.alpha = 1
            self.playerView?.player.pause()
            self.playerView?.delegate = nil
            
            configurePreviewView(animated: false)
        }
    }
    
    private func configurePlayerView(animated animated: Bool) {
        guard let playerView = playerView, let assetFactory = currentVideoAssetFactory else { return }
        guard fullScreenMode else { return }
        
        let asset = assetFactory()
        playerView.player.setAsset(asset)
        contentViewSwitcher.changeSwitcherState(asset.isCached ? .Success : .Loading, animated: animated)
        playerView.player.play()
    }
    
    private func configurePreviewView(animated animated: Bool) {
        guard let video = currentVideo else { return }
        
        previewView.imageView.image = nil
        let onRetrieveFromCache: UIImage? -> Void = { [weak self]image in
            guard let `self` = self else { return }
            guard !self.fullScreenMode else { return }
            self.contentViewSwitcher.changeSwitcherState(image == nil ? .Loading : .Success, animated: animated)
        }
        let onSuccess: (UIImage) -> () = { [weak self] image in
            guard let `self` = self else { return }
            guard !self.fullScreenMode else { return }
            self.contentViewSwitcher.changeSwitcherState(.Success)
        }
        previewView.imageView.loadImageFromUrl(video.previewImageUrl, width: self.bounds.width, onRetrievedFromCache: onRetrieveFromCache, success: onSuccess)
    }
    
    private func configureContentInsets() {
        let screenBottomInset = screenInset?.bottom ?? 0
        let fullScreenBottomInset = fullScreenInset?.bottom ?? 0
        previewView.playImageCenterYConstraint?.updateOffset(-screenBottomInset / 2)
        let loadingContentInset = fullScreenMode ? -fullScreenBottomInset / 2 : -screenBottomInset / 2
        contentViewSwitcher.loadingView.indicatorCenterYOffset = loadingContentInset
    }
    
    // MARK:- VIMVideoPlayerViewDelegate
    
    func videoPlayerViewDidReachEnd(videoPlayerView: VIMVideoPlayerView!) {
        guard fullScreenMode else { return }
        delegate?.productImageVideoCellDidFinishVideo(self)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        guard fullScreenMode else { return }
        let videoStarted = cmTime.seconds > 0 && previewView.alpha == 1
        if videoStarted {
            let shouldChangeSwitcherState = contentViewSwitcher.switcherState != .Success
            UIView.animateWithDuration(shouldChangeSwitcherState ? 0 : contentViewSwitcher.animationDuration) { [unowned self]in
                self.previewView.alpha = 0
            }
            if shouldChangeSwitcherState {
                contentViewSwitcher.changeSwitcherState(.Success, animated: true)
            }
        }
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange loadedDurationSeconds: Double) {
        guard fullScreenMode else { return }
        guard let durationSeconds = videoPlayerView.playerItemDurationSeconds else {
            logError("Unable to determine if video finished loading: duration unknown")
            return
        }
        logInfo("loaded time range: \(loadedDurationSeconds)/\(durationSeconds) \(lastVideoLoadedDuration)")
        if loadedDurationSeconds.almostEqual(to: durationSeconds) && !loadedDurationSeconds.almostEqual(to: lastVideoLoadedDuration ?? -1.0) {
            if let asset = videoPlayerView.player.currentAsset {
                delegate?.productImageVideoCellDidLoadVideo(self, asset: asset)
            } else {
                logError("No asset")
            }
        }
        lastVideoLoadedDuration = loadedDurationSeconds
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!) {
        guard fullScreenMode else { return }
        contentViewSwitcher.changeSwitcherState(.Error, animated: true)
        delegate?.productImageVideoCellFailedToLoadVideo(self)
    }
}

extension ProductImageVideoCell: ViewSwitcherDataSource {
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}

extension ProductImageVideoCell: ViewSwitcherDelegate {
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        if fullScreenMode {
            configurePlayerView(animated: true)
        } else {
            configurePreviewView(animated: true)
        }
    }
}

final private class ProductImageVideoPreviewView: UIView {
    private let imageView: UIImageView
    private let playImageView: UIImageView
    private var playImageCenterYConstraint: Constraint?
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        playImageView = UIImageView(image: UIImage(asset: .Play_product))
        
        super.init(frame: frame)
        
        imageView.contentMode = .ScaleAspectFill
        
        addSubview(imageView)
        addSubview(playImageView)
        
        imageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playImageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            playImageCenterYConstraint = make.centerY.equalToSuperview().constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
