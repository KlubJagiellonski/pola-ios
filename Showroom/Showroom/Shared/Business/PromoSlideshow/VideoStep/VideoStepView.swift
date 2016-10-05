import UIKit
import AVKit
import AVFoundation

protocol VideoStepViewDelegate: class {
    func videoStepIsReadyToPlay(view: VideoStepView)
    func videoStepViewDidTapPlayerView(view: VideoStepView)
    func videoStepView(view: VideoStepView, timeDidChange cmTime: CMTime)
    func videoStepViewDidReachedEnd(view: VideoStepView)
    func videoStepViewDidLoadVideo(view: VideoStepView)
}

final class VideoStepView: ViewSwitcher, VIMVideoPlayerViewDelegate {
    private let playerView = VIMVideoPlayerView()
    
    var playing: Bool {
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
    
    init(link: String) {
        super.init(successView: playerView, initialState: .Loading)
        switcherDataSource = self
        switcherDelegate = self
        
        let url = NSURL(string: link)!
        playerView.player.setURL(url)
        playerView.player.looping = false
        playerView.player.disableAirplay()
        playerView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoStepView.didTapPlayerView))
        playerView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayerView() {
        delegate?.videoStepViewDidTapPlayerView(self)
        playing = !playing
    }
    
    func videoPlayerViewIsReadyToPlayVideo(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("ready to play video")
        delegate?.videoStepIsReadyToPlay(self)
        changeSwitcherState(.Success, animated: true)
    }
    
    func videoPlayerViewDidReachEnd(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("did reached end")
        delegate?.videoStepViewDidReachedEnd(self)
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        delegate?.videoStepView(self, timeDidChange: cmTime)
    }
    
    // TODO:- check when called
    func videoPlayerViewPlaybackBufferEmpty(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("buffer empty")
        changeSwitcherState(.Loading, animated: true)
    }
    
    // TODO:- check when called
    func videoPlayerViewPlaybackLikelyToKeepUp(videoPlayerView: VIMVideoPlayerView!) {
        logInfo("playback likely to keep up")
        changeSwitcherState(.Success, animated: true)
    }
    
    // TODO:- check when called
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!) {
        logInfo("did fail with error: \(error)")
        changeSwitcherState(.Error, animated: true)
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
}

extension VideoStepView: ViewSwitcherDelegate, ViewSwitcherDataSource {
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("view switcher retry")
        playing = true
        changeSwitcherState(.Loading, animated: true)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}