import Foundation
import AVKit
import AVFoundation

final class VideoStepViewController: UIViewController, PromoPageInterface, VideoStepViewDelegate {
    private var castView: VideoStepView { return view as! VideoStepView }
    private let url: NSURL
    private let annotations: [PromoSlideshowVideoAnnotation]
    private var additionalData: VideoStepAdditionalData?
    private lazy var asset: AVURLAsset = { [unowned self] in
        return self.retrieveOrCreateAsset()
    }()
    private let cacheHelper: VideoStepCacheHelper
    
    weak var pageDelegate: PromoPageDelegate?
    var shouldShowProgressViewInPauseState: Bool { return true }
    
    var pageState: PromoPageState {
        didSet {
            let (focused, playing) = (pageState.focused, pageState.playing)
            logInfo("set focused: \(focused), playing: \(playing)")
            
            if focused != oldValue.focused || playing != oldValue.playing {
                if focused && playing {
                    castView.play()
                } else if focused && !playing {
                    castView.pause()
                    guard let duration = castView.playerItemDuration, let playbackTime = castView.playbackTime else {
                        logInfo("Could not get player item duration or playback time")
                        pageDelegate?.promoPage(self, didChangeCurrentProgress: 0.0)
                        return
                    }
                    let currentProgress = playbackTime == 0 ? 0.0 : Double(playbackTime) / Double(duration)
                    pageDelegate?.promoPage(self, didChangeCurrentProgress: currentProgress)
                } else if !focused {
                    castView.pause()
                }
            }
        }
    }
    
    init(with resolver: DiResolver, link: String, annotations: [PromoSlideshowVideoAnnotation], additionalData: AnyObject?, pageState: PromoPageState) {
        self.url = NSURL(string: link)!
        self.annotations = annotations
        self.pageState = pageState
        self.additionalData = additionalData as? VideoStepAdditionalData
        
        self.cacheHelper =  VideoStepCacheHelper(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = VideoStepView(asset: asset, annotations: annotations, prefetchedPlayerView: additionalData?.playerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    private func retrieveOrCreateAsset() -> AVURLAsset {
        var asset: AVURLAsset!
        if let additionalData = self.additionalData {
            asset = additionalData.asset
        } else {
            let url = self.cacheHelper.cachedFileUrl ?? self.url
            asset = AVURLAsset(URL: url)
        }
        asset.resourceLoader.setDelegate(self.cacheHelper, queue: dispatch_get_main_queue())
        return asset
    }
    
    // MARK:- VideoStepViewDelegate
    
    func videoStepViewDidTapPlayerView(view: VideoStepView) {
        logInfo("did tap player view")
        switch castView.state {
        case .PlayedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Playing, animationDuration: 0.4)
        case .PausedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused(shouldShowProgressViewInPauseState), animationDuration: 0.4)
        default:
            logError("Unexpected video step state: \(castView.state)")
        }
    }
    
    func videoStepView(view: VideoStepView, didChangePlaybackTime playbackTime: Int) {
        guard let duration = castView.playerItemDuration else {
            logInfo("Could not get final duration")
            return
        }
        let currentProgress = playbackTime == 0 ? 0.0 : Double(playbackTime) / Double(duration)
        pageDelegate?.promoPage(self, didChangeCurrentProgress: currentProgress)
    }
    
    func videoStepViewDidReachedEnd(view: VideoStepView) {
        logInfo("did reach end")
        pageDelegate?.promoPageDidFinished(self)
    }
    
    func videoStepViewDidLoadVideo(view: VideoStepView) {
        logInfo("did load video")
        cacheHelper.saveToCache(with: asset)
        pageDelegate?.promoPageDidDownloadAllData(self)
    }
    
    func videoStepViewFailedToLoadVideo(view: VideoStepView) {
        logInfo("failed to load video")
        cacheHelper.clearCache()
    }
    
    func videoStepViewDidTapRetry(view: VideoStepView) {
        logInfo("did tap retry")
        asset = retrieveOrCreateAsset()
        castView.update(asset)
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        logInfo("did tap play")
        pageDelegate?.promoPage(self, willChangePromoPageViewState: .Playing, animationDuration: 0.4)
    }
    
    func didTapDismiss() {}
    
    func resetProgressState() {
        castView.stop()
    }
}
