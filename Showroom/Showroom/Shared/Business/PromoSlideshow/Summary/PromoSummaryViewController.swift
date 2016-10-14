import Foundation

final class PromoSummaryViewController: UIViewController, PromoPageInterface, PromoSummaryViewDelegate {
    weak var pageDelegate: PromoPageDelegate?
    var focused: Bool = false {
        didSet {
            logInfo("focused did set: \(focused)")
            if focused {
                castView.startActions()
            } else {
                castView.stopActions()
            }
        }
    }
    var shouldShowProgressViewInPauseState: Bool { return false }
    
    private var castView: PromoSummaryView { return view as! PromoSummaryView }
    private let promoSlideshow: PromoSlideshow
    
    init(with resolver: DiResolver, promoSlideshow: PromoSlideshow) {
        self.promoSlideshow = promoSlideshow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = PromoSummaryView(promoSlideshow: promoSlideshow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
    }
    
    // MARK:- PromoSummaryViewDelegate
    
    func promoSummaryDidTapRepeat(promoSummary: PromoSummaryView) {
        logInfo("Did tap repeat")
        sendNavigationEvent(ShowVideoEvent(id: promoSlideshow.playlist[0].id))
    }
    
    func promoSummary(promoSummary: PromoSummaryView, didTapLink link: PromoSlideshowLink) {
        logInfo("Did tap link \(link)")
        sendNavigationEvent(ShowItemForLinkEvent(link: link.link, title: link.text, productDetailsFromType: .Video))
    }
    
    func promoSummary(promoSummary: PromoSummaryView, didTapPlayForVideo video: PromoSlideshowPlaylistItem) {
        logInfo("Did tap play video \(video)")
        sendNavigationEvent(ShowVideoEvent(id: video.id))
    }

    // MARK:- PromoPageInterface
    
    func didTapPlay() {}
    
    func didTapDismiss() {}
}