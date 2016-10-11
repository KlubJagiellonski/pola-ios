import Foundation
import AVKit
import AVFoundation

final class VideoStepViewController: UIViewController, PromoPageInterface, VideoStepViewDelegate {
    private let timeObserverInterval: Int = 100
    private var passedInitialReadyToPlay: Bool = false
    
    private var castView: VideoStepView { return view as! VideoStepView }
    private let link: String
    private let annotations: [PromoSlideshowVideoAnnotation]
    private var duration: Int?
    private var timeObserver: AnyObject?
    
    weak var pageDelegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, link: String, annotations: [PromoSlideshowVideoAnnotation]) {
        self.link = link
        self.annotations = annotations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = VideoStepView(link: link, annotations: annotations)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    // TODO: begin prefetching after view creation
    
    // MARK:- VideoStepViewDelegate
    
    func videoStepIsReadyToPlay(view: VideoStepView) {
        duration = castView.duration
    }
    
    func videoStepViewDidTapPlayerView(view: VideoStepView) {
        logInfo("did tap player view")
        switch castView.state {
        case .PlayedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: 0.4)
        case .PausedByUser: pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused, animationDuration: 0.4)
        default:
            logError("Unexpected video step state: \(castView.state)")
        }
    }
    
    func videoStepView(view: VideoStepView, timeDidChange cmTime: CMTime) {
        guard let duration = duration else {
            logInfo("Duration not set")
            return
        }
        let currentSeconds = cmTime.seconds
        let currentProgress = (currentSeconds * 1000) / Double(duration)
        pageDelegate?.promoPage(self, didChangeCurrentProgress: currentProgress)
    }
    
    func videoStepViewDidReachedEnd(view: VideoStepView) {
        pageDelegate?.promoPageDidFinished(self)
    }
    
    func videoStepViewDidLoadVideo(view: VideoStepView) {
        logInfo("did load video")
        pageDelegate?.promoPageDidDownloadAllData(self)
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        castView.play()
        pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: 0.4)
    }
    
    func didTapDismiss() { }
    
    func pageGainedFocus(with reason: PromoFocusChangeReason) {
        logInfo("VideoStep gained focus")
        castView.play()
        if reason == .AppForegroundChanged {
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
        }
    }
    
    func pageLostFocus(with reason: PromoFocusChangeReason) {
        logInfo("VideoStep lost focus")
        castView.pause()
        if reason == .AppForegroundChanged {
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused, animationDuration: 0.4)
        }
        
    }
}