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
    func videoStepView(view: VideoStepView, timeDidChange cmTime: CMTime)
    func videoStepViewDidReachedEnd(view: VideoStepView)
    func videoStepViewDidLoadVideo(view: VideoStepView)
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
    var playbackDuration: Int? {
        return playerView.playbackDurationMillis
    }
    var playerItem: AVPlayerItem? {
        return playerView.player.player.currentItem
    }
    
    private var lastLoadedDuration: Double?
    
    weak var delegate: VideoStepViewDelegate?
    
    private var asset: AVAsset

    init(asset: AVAsset, annotations: [PromoSlideshowVideoAnnotation], prefetchedPlayerView: VIMVideoPlayerView?) {
        annotationsView = VideoStepAnnotationsView(annotations: annotations)
        self.asset = asset
        self.playerView = prefetchedPlayerView ?? VIMVideoPlayerView()
        let prefetchedPlayerExist = (prefetchedPlayerView != nil)
        super.init(successView: playerView, initialState: (prefetchedPlayerExist || asset.isCached) ? .Success : .Loading)

        switcherDataSource = self
        switcherDelegate = self
        
        if !prefetchedPlayerExist {
            playerView.player.setAsset(asset)
            playerView.applyDefaultConfiguration()
        }
        playerView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoStepView.didTapPlayerView))
        playerView.addGestureRecognizer(tap)
        
        playerView.addSubview(annotationsView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        logInfo("play")
        state = .PlayedByUser
    }
    
    func pause() {
        logInfo("pause")
        state = .PausedByUser
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
        changeSwitcherState(.Success, animated: true)
        playerPlaying = true
        state = .PlayedByPlayer
    }
    
    func videoPlayerViewDidReachEnd(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("did reached end")
        delegate?.videoStepViewDidReachedEnd(self)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        annotationsView.playbackTimeChanged(Int(cmTime.seconds * 1000))
        delegate?.videoStepView(self, timeDidChange: cmTime)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!) {
        logInfo("did fail with error: \(error)")
        state = .PausedByPlayer
        changeSwitcherState(.Error, animated: true)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange loadedDurationSeconds: Double) {
        guard let durationSeconds = playerView.playbackDurationSeconds else {
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

        guard lastLoadedDuration != playerView.playbackDurationSeconds else {
            return
        }
        
        if rate == 0.0 {
            switch state {
            case .PlayedByUser, .PlayedByPlayer:
                state = .PausedByPlayer
                changeSwitcherState(.Loading, animated: true)
            case .PausedByUser, .PausedByPlayer:
                break
            }
        } else {
            switch state {
            case .PausedByPlayer:
                state = .PlayedByPlayer
                changeSwitcherState(.Success, animated: true)
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
        playerView.player.setAsset(asset)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}

extension AVAsset {
    var isCached: Bool {
        guard let urlAsset = self as? AVURLAsset else { return false }
        return urlAsset.URL.scheme == "file"
    }
}