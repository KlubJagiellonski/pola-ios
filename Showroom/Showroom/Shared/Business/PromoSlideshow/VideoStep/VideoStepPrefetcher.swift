import Foundation
import RxSwift

class VideoStepAdditionalData {
    let asset: AVURLAsset
    let playerView: VIMVideoPlayerView
    
    init(asset: AVURLAsset, playerView: VIMVideoPlayerView) {
        self.asset = asset
        self.playerView = playerView
    }
}

final class VideoStepPrefetcher: PromoSlideshowPagePrefetcher {
    private let prefetchDurationInSecondsThreshold: Double = 6
    
    var additionalData: AnyObject? {
        guard let currentPlayer = currentPlayer else {
            return nil
        }
        return VideoStepAdditionalData(asset: asset, playerView: currentPlayer)
    }
    private let url: NSURL
    private let playerDelegate = VIMVideoPlayerViewDelegateHandler()
    private var currentPlayer: VIMVideoPlayerView?
    private var currentPrefetchObserver: AnyObserver<AnyObject?>?
    private let cacheHelper: VideoStepCacheHelper
    private lazy var asset: AVURLAsset = { [unowned self] in
        let asset = AVURLAsset(URL: self.url)
        asset.resourceLoader.setDelegate(self.cacheHelper, queue: dispatch_get_main_queue())
        return asset
    }()
    
    init(data: PromoSlideshowPageData) {
        guard case let .Video(link, _) = data else {
            fatalError("Prefetcher created with from data \(data)")
        }
        self.url = NSURL(string: link)!
        self.cacheHelper = VideoStepCacheHelper(url: self.url)
        self.playerDelegate.prefetcher = self
    }
    
    func prefetch() -> Observable<AnyObject?> {
        return Observable.create { [unowned self] observer in
            if self.cacheHelper.cachedFileUrl != nil {
                //if there is already cached file we don't want to create player. Just send next and completed
                observer.onNext(nil)
                observer.onCompleted()
            } else {
                self.startPlayer(with: observer)
            }
            
            return AnonymousDisposable { [unowned self] in
                self.resetPlayer()
            }
        }
    }
    
    private func startPlayer(with observer: AnyObserver<AnyObject?>) {
        let playerView = VIMVideoPlayerView()
        playerView.player.setAsset(asset)
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
        guard let playbackDuration = currentPlayer?.playerItemDurationSeconds else { return }
        
        logInfo("Prefetched time range \(duration)")
        
        if duration > prefetchDurationInSecondsThreshold || duration >= playbackDuration {
            logInfo("Did prefetch with duration \(duration)")
            currentPrefetchObserver?.onNext(additionalData)
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
