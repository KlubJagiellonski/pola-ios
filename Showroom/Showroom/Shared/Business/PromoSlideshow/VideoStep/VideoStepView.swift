import UIKit
import AVKit
import AVFoundation

enum VideoStepViewState {
    case PlayedByUser
    case PlayedByPlayer
    case PausedByUser
    case PausedByPlayer
}

protocol VideoStepViewDelegate: class {
    func videoStepViewDidTapPlayerView(view: VideoStepView)
    func videoStepView(view: VideoStepView, didChangePlaybackTime playbackTime: Int)
    func videoStepViewDidReachedEnd(view: VideoStepView)
    func videoStepViewDidLoadVideo(view: VideoStepView)
    func videoStepViewFailedToLoadVideo(view: VideoStepView)
    func videoStepViewDidTapRetry(view: VideoStepView)
}

final class VideoStepView: ViewSwitcher, VIMVideoPlayerViewDelegate {
    private let playerView: VIMVideoPlayerView
    private let annotationsView: VideoStepAnnotationsView
    
    private(set) var state: VideoStepViewState = .PausedByPlayer {
        didSet {
            logInfo("did set state: \(state)")
            switch state {
            case .PlayedByUser: playerPlaying = true
            case .PausedByUser: playerPlaying = false
            default: break
            }
        }
    }
    private var playerPlaying: Bool {
        set {
            guard newValue != playerView.player.playing else { return }
            newValue ? playerView.player.play() : playerView.player.pause()
        }
        get { return playerView.player.playing }
    }
    var playerItemDuration: Int? {
        return playerView.playerItemDurationMillis
    }
    var playbackTime: Int? {
        return playerView.playbackTimeMillis
    }
    var playerItem: AVPlayerItem? {
        return playerView.player.player.currentItem
    }
    private var lastLoadedDuration: Double?
    private var shouldChangeSwitcherStateOnRateChange: Bool
    
    weak var delegate: VideoStepViewDelegate?

    init(asset: AVAsset, annotations: [PromoSlideshowVideoAnnotation], prefetchedPlayerView: VIMVideoPlayerView?) {
        annotationsView = VideoStepAnnotationsView(annotations: annotations)
        self.playerView = prefetchedPlayerView ?? VIMVideoPlayerView()
        let prefetchedPlayerExist = (prefetchedPlayerView != nil)
        self.shouldChangeSwitcherStateOnRateChange = !(prefetchedPlayerExist || asset.isCached)
        super.init(successView: playerView, initialState: (prefetchedPlayerExist || asset.isCached) ? .Success : .Loading)

        switcherDataSource = self
        switcherDelegate = self
        
        if !prefetchedPlayerExist {
            playerView.player.setAsset(asset)
            playerView.applyDefaultConfiguration()
        }
        playerView.player.pause()
        playerView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoStepView.didTapPlayerView))
        playerView.addGestureRecognizer(tap)
        
        playerView.addSubview(annotationsView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(asset: AVAsset) {
        playerView.player.setAsset(asset)
    }
    
    func play() {
        logInfo("play")
        state = .PlayedByUser
    }
    
    func pause() {
        logInfo("pause")
        state = .PausedByUser
    }
    
    func stop() {
        logInfo("stop")
        state = .PausedByUser
        playerView.player.player.seekToTime(kCMTimeZero)
    }

    private func configureCustomConstraints() {
        annotationsView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapPlayerView() {
        switch state {
        case .PlayedByUser, .PlayedByPlayer: state = .PausedByUser
        case .PausedByUser: state = .PlayedByUser
        default: break
        }
        logInfo("delegate: \(delegate)")
        delegate?.videoStepViewDidTapPlayerView(self)
    }

    func videoPlayerViewIsReadyToPlayVideo(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("ready to play video")
        shouldChangeSwitcherStateOnRateChange = true
        changeSwitcherState(.Success, animated: true)
    }
    
    func videoPlayerViewDidReachEnd(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("did reached end")
        delegate?.videoStepViewDidReachedEnd(self)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        let playbackTime = Int(cmTime.seconds * Double(1000))
        annotationsView.playbackTimeChanged(playbackTime)
        delegate?.videoStepView(self, didChangePlaybackTime: playbackTime)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!) {
        logInfo("did fail with error: \(error)")
        delegate?.videoStepViewFailedToLoadVideo(self)
        state = .PausedByPlayer
        changeSwitcherState(.Error, animated: true)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange loadedDurationSeconds: Double) {
        guard let durationSeconds = playerView.playerItemDurationSeconds else {
            logError("Unable to determine if video finished loading: duration unknown")
            return
        }
        logInfo("loaded time range: \(loadedDurationSeconds)/\(durationSeconds) \(lastLoadedDuration)")
        if loadedDurationSeconds.almostEqual(to: durationSeconds) && !loadedDurationSeconds.almostEqual(to: lastLoadedDuration ?? -1.0) {
            delegate?.videoStepViewDidLoadVideo(self)
        }
        lastLoadedDuration = loadedDurationSeconds
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didChangeRate rate: Double) {
        logInfo("video player view did change rate: \(rate)")
        
        //we don't won't to update state when we reached end of video
        guard playbackTime != playerItemDuration else { return }
        
        if rate == 0.0 {
            switch state {
            case .PlayedByUser, .PlayedByPlayer:
                state = .PausedByPlayer
                if shouldChangeSwitcherStateOnRateChange {
                    changeSwitcherState(.Loading, animated: true)
                }
            case .PausedByUser, .PausedByPlayer:
                break
            }
        } else {
            switch state {
            case .PausedByPlayer:
                state = .PlayedByPlayer
                if shouldChangeSwitcherStateOnRateChange {
                    changeSwitcherState(.Success, animated: true)
                }
            case .PlayedByUser, .PlayedByPlayer, .PausedByUser:
                break
            }
        }
    }
}

extension VideoStepView: ViewSwitcherDelegate, ViewSwitcherDataSource {
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("view switcher retry")

        changeSwitcherState(.Loading, animated: false)
        delegate?.videoStepViewDidTapRetry(self)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}
