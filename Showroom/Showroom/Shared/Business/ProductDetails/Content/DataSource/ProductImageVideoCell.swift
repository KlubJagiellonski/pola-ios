import Foundation
import UIKit
import SnapKit

protocol ProductImageVideoCellDelegate: class {
    func productImageVideoCellDidFinishVideo(cell: ProductImageVideoCell)
    func productImageVideoCellDidLoadVideo(cell: ProductImageVideoCell, asset: AVAsset)
    func productImageVideoCellFailedToLoadVideo(cell: ProductImageVideoCell)
    func productImageVideoCellDidTapPlay(cell: ProductImageVideoCell)
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
    private var lastVideoLoadedDuration: Double?
    weak var delegate: ProductImageVideoCellDelegate?
    
    override init(frame: CGRect) {
        contentViewSwitcher = ViewSwitcher(successView: successContentView)
        super.init(frame: frame)
        
        previewView.playButton.addTarget(self, action: #selector(ProductImageVideoCell.didTapPlay), forControlEvents: .TouchUpInside)
        
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
        if fullScreenMode {
            showPreviewView()
        }
        configurePreviewView(animated: false)
    }
    
    func didEndDisplaying() {
        playerView?.player.reset()
    }
    
    @objc private func didTapPlay() {
        delegate?.productImageVideoCellDidTapPlay(self)
        
        showPlayerView()
        configurePlayerView(animated: true)
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
        if !fullScreenMode {
            showPreviewView()
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
            guard self.previewView.alpha == 1 else { return }
            self.contentViewSwitcher.changeSwitcherState(image == nil ? .Loading : .Success, animated: animated)
        }
        let onSuccess: (UIImage) -> () = { [weak self] image in
            guard let `self` = self else { return }
            guard self.previewView.alpha == 1 else { return }
            self.contentViewSwitcher.changeSwitcherState(.Success)
        }
        previewView.imageView.loadImageFromUrl(video.previewImageUrl, width: self.bounds.width, onRetrievedFromCache: onRetrieveFromCache, success: onSuccess)
    }
    
    private func showPreviewView() {
        self.previewView.playButton.enabled = true
        
        self.previewView.alpha = 1
        self.playerView?.player.pause()
        self.playerView?.delegate = nil
    }
    
    private func showPlayerView() {
        self.previewView.playButton.enabled = false
        
        self.playerView?.removeFromSuperview()
        
        let playerView = VIMVideoPlayerView(frame: bounds)
        playerView.delegate = self
        successContentView.insertSubview(playerView, atIndex: 0)
        self.playerView = playerView
        
        playerView.snp_makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    private func configureContentInsets() {
        let screenBottomInset = screenInset?.bottom ?? 0
        let contentInset = fullScreenMode ? 0 : -screenBottomInset / 2
        previewView.playImageCenterYConstraint?.updateOffset(contentInset)
        contentViewSwitcher.loadingView.indicatorCenterYOffset = contentInset
        
        previewView.layoutIfNeeded()
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
    private let playButton = UIButton()
    private var playImageCenterYConstraint: Constraint?
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        
        super.init(frame: frame)
        
        imageView.contentMode = .ScaleAspectFill
        playButton.setImage(UIImage(asset: .Play_product), forState: .Normal)
        
        addSubview(imageView)
        addSubview(playButton)
        
        imageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            playImageCenterYConstraint = make.centerY.equalToSuperview().constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
