import Foundation
import RxSwift

final class VideoStepPrefetcher: PromoSlideshowPagePrefetcher {
    private let prefetchDurationInSecondsThreshold: Double = 3
    
    var additionalData: AnyObject? { return currentPlayer }
    private let link: String
    private let playerDelegate = VIMVideoPlayerViewDelegateHandler()
    private var currentPlayer: VIMVideoPlayerView?
    private var currentPrefetchObserver: AnyObserver<AnyObject?>?
    
    init(data: PromoSlideshowPageData) {
        guard case let .Video(link, _) = data else {
            fatalError("Prefetcher created with from data \(data)")
        }
        self.link = link
        self.playerDelegate.prefetcher = self
    }
    
    func prefetch() -> Observable<AnyObject?> {
        return Observable.create { [unowned self] observer in
            self.startPlayer(with: observer)
            
            return AnonymousDisposable { [unowned self] in
                self.resetPlayer()
            }
        }
    }
    
    private func startPlayer(with observer: AnyObserver<AnyObject?>) {
        let playerView = VIMVideoPlayerView()
        playerView.player.setURL(NSURL(string: link)!)
        playerView.applyDefaultConfiguration()
        playerView.delegate = playerDelegate
        self.currentPlayer = playerView
        self.currentPrefetchObserver = observer
    }
    
    private func resetPlayer() {
        currentPlayer = nil
        currentPrefetchObserver = nil
    }
    
    private func didLoadTimeRange(withDuration duration: Double) {
        guard let playbackDuration = currentPlayer?.playbackDurationSeconds else { return }
        
        if duration > prefetchDurationInSecondsThreshold || duration >= playbackDuration {
            logInfo("Did prefetch with duration \(duration)")
            currentPrefetchObserver?.onNext(currentPlayer)
            currentPrefetchObserver?.onCompleted()
            resetPlayer()
        }
    }
    
    private func didFail(with error: NSError) {
        logInfo("Did fail \(error)")
        currentPrefetchObserver?.onError(CommonError.UnknownError(error))
        resetPlayer()
    }
}

final private class VIMVideoPlayerViewDelegateHandler: NSObject, VIMVideoPlayerViewDelegate {
    weak var prefetcher: VideoStepPrefetcher?
    
    @objc private func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, loadedTimeRangeDidChange duration: Double) {
        prefetcher?.didLoadTimeRange(withDuration: duration)
    }
    
    @objc private func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, didFailWithError error: NSError!) {
        prefetcher?.didFail(with: error)
    }
}