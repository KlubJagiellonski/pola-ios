import Foundation
import UIKit

final class ImageStepViewController: UIViewController, PromoPageInterface, ImageStepViewDelegate {
    private let link: String
    private let duration: Int

    private lazy var timer: Timer = {
        let timer = Timer(duration: self.duration, stepInterval: Constants.promoSlideshowTimerStepInterval)
        timer.delegate = self
        return timer
    }()
    
    private var castView: ImageStepView { return view as! ImageStepView }
    
    weak var pageDelegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, link: String, duration: Int) {
        self.link = link
        self.duration = duration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ImageStepView(link: link)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
        castView.loadImage()
    }
    
    // MARK:- ImageStepViewDelegate
    
    func imageStepViewDidDownloadImage(view: ImageStepView) {
        logInfo("image step view did download image")
        pageDelegate?.promoPageDidDownloadAllData(self)
        timer.play()
    }
    
    func imageStepViewDidTapImageView(view: ImageStepView) {
        logInfo("image step view did tap")
        if timer.paused {
            timer.play()
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
        } else {
            timer.pause()
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
        }
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        logInfo("did tap play")
        timer.play()
        pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
    }
    
    func didTapDismiss() { }
    
    func pageLostFocus(with reason: PromoFocusChangeReason) {
        logInfo("ImageStep lost focus")
        if reason == .AppForegroundChanged {
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Paused, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
        }
        timer.pause()
    }
    
    func pageGainedFocus(with reason: PromoFocusChangeReason) {
        logInfo("ImageStep gained focus \(reason)")
        if reason == .AppForegroundChanged {
            pageDelegate?.promoPage(self, willChangePromoPageViewState: .Close, animationDuration: Constants.promoSlideshowStateChangedAnimationDuration)
        }
        timer.play()
    }
}

extension ImageStepViewController: TimerDelegate {
    func timer(timer: Timer, didChangeProgress progress: Double) {
        pageDelegate?.promoPage(self, didChangeCurrentProgress: progress)
    }
    
    func timerDidEnd(timer: Timer) {
        pageDelegate?.promoPageDidFinished(self)
    }
}