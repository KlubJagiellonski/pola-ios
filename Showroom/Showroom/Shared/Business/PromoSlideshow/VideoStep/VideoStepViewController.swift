import Foundation
import AVKit
import AVFoundation

final class VideoStepViewController: UIViewController, PromoPageInterface, VideoStepViewDelegate {
    private var castView: VideoStepView { return view as! VideoStepView }
    private let url: NSURL
    private let annotations: [PromoSlideshowVideoAnnotation]
    private var additionalData: VideoStepAdditionalData?
    private lazy var asset: AVURLAsset = { [unowned self] in
        let asset = self.retrieveOrCreateAsset()
        asset.resourceLoader.setDelegate(self.cacheHelper, queue: dispatch_get_main_queue())
        return asset
    }()
    private let cacheHelper: VideoStepCacheHelper
    
    weak var pageDelegate: PromoPageDelegate?
    var focused: Bool = false {
        didSet {
            logInfo("focused did set: \(focused)")
            if focused {
                castView.play()
            } else {
                castView.pause()
            }
        }
    }
    var shouldShowProgressViewInPauseState: Bool { return true }
    
    init(with resolver: DiResolver, link: String, annotations: [PromoSlideshowVideoAnnotation], additionalData: AnyObject?) {
        self.url = NSURL(string: link)!
        self.annotations = annotations
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
        if let additionalData = self.additionalData {
            return additionalData.asset
        } else {
            let url = self.cacheHelper.cachedFileUrl ?? self.url
            return AVURLAsset(URL: url)
        }
    }
    
    // MARK:- VideoStepViewDelegate
    
    func videoStepViewDidTapPlayerView(view: VideoStepView) {
        logInfo("did tap player view")
        switch castView.state {
        case .PlayedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: 0.4)
        case .PausedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused(shouldShowProgressViewInPauseState), animationDuration: 0.4)
        default:
            logError("Unexpected video step state: \(castView.state)")
        }
    }
    
    func videoStepView(view: VideoStepView, timeDidChange cmTime: CMTime) {
        guard let duration = castView.playbackDuration else {
            logInfo("Duration not set")
            return
        }
        let currentSeconds = cmTime.seconds
        let currentProgress = duration == 0 ? 0.0 : (currentSeconds * 1000) / Double(duration)
        pageDelegate?.promoPage(self, didChangeCurrentProgress: currentProgress)
    }
    
    func videoStepViewDidReachedEnd(view: VideoStepView) {
        pageDelegate?.promoPageDidFinished(self)
    }
    
    func videoStepViewDidLoadVideo(view: VideoStepView) {
        logInfo("did load video")
        cacheHelper.saveToCache(with: asset)
        pageDelegate?.promoPageDidDownloadAllData(self)
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        logInfo("did tap play")
        castView.play()
        pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: 0.4)
    }
    
    func didTapDismiss() { }
}