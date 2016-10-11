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
    func videoStepIsReadyToPlay(view: VideoStepView)
    func videoStepViewDidTapPlayerView(view: VideoStepView)
    func videoStepView(view: VideoStepView, timeDidChange cmTime: CMTime)
    func videoStepViewDidReachedEnd(view: VideoStepView)
    func videoStepViewDidLoadVideo(view: VideoStepView)
}

final class VideoStepView: ViewSwitcher, VIMVideoPlayerViewDelegate {
    private var playerView = VIMVideoPlayerView()
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
    var duration: Int? {
        guard let durationSeconds = durationSeconds else { return nil }
        return Int(durationSeconds * 1000)
    }
    private var durationSeconds: Double? {
        guard let cmTime = playerView.player.player.currentItem?.asset.duration else { return nil }
        return cmTime.seconds
    }
    private var lastLoadedDuration: Double?
    
    weak var delegate: VideoStepViewDelegate?
    
    private var url: NSURL

    init(link: String, annotations: [PromoSlideshowVideoAnnotation]) {
        annotationsView = VideoStepAnnotationsView(annotations: annotations)
        self.url = NSURL(string: link)!
        super.init(successView: playerView, initialState: .Loading)

        switcherDataSource = self
        switcherDelegate = self
        
        playerView.player.setURL(url)
        playerView.player.looping = false
        playerView.player.disableAirplay()
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
        state = .PlayedByUser
    }
    
    func pause() {
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
        delegate?.videoStepViewDidTapPlayerView(self)
    }

    func videoPlayerViewIsReadyToPlayVideo(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("ready to play video")
        delegate?.videoStepIsReadyToPlay(self)
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
        changeSwitcherState(.ModalError, animated: true)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange loadedDurationSeconds: Double) {
        guard let durationSeconds = durationSeconds else {
            logError("Unable to determine if video finished loading: duration unknown")
            return
        }
        logInfo("loaded time range: \(loadedDurationSeconds)/\(durationSeconds)")
        if loadedDurationSeconds == self.durationSeconds && loadedDurationSeconds != lastLoadedDuration {
            delegate?.videoStepViewDidLoadVideo(self)
        }
        lastLoadedDuration = loadedDurationSeconds
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didChangeRate rate: Double) {
        logInfo("video player view did change rate: \(rate)")

        if rate == 0.0 {
            switch state {
            case .PlayedByUser, .PlayedByPlayer:
                state = .PausedByPlayer
                changeSwitcherState(.ModalLoading, animated: true)
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

        changeSwitcherState(.ModalLoading, animated: false)
        playerView.player.setURL(url)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}