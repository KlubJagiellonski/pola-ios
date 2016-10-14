import Foundation
import AVKit
import AVFoundation

final class VideoStepViewController: UIViewController, PromoPageInterface, VideoStepViewDelegate {
    private var castView: VideoStepView { return view as! VideoStepView }
    private let link: String
    private let annotations: [PromoSlideshowVideoAnnotation]
    private var additionalData: AnyObject?
    
    weak var pageDelegate: PromoPageDelegate?
    var focused: Bool = false {
        didSet {
            if focused {
                castView.play()
            } else {
                castView.pause()
            }
        }
    }
    var shouldShowProgressViewInPauseState: Bool { return true }
    
    init(with resolver: DiResolver, link: String, annotations: [PromoSlideshowVideoAnnotation], additionalData: AnyObject?) {
        self.link = link
        self.annotations = annotations
        self.additionalData = additionalData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = VideoStepView(link: link, annotations: annotations, additionalData: additionalData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
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
        pageDelegate?.promoPageDidDownloadAllData(self)
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        castView.play()
        pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: 0.4)
    }
    
    func didTapDismiss() { }
}