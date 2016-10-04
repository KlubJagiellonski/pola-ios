import Foundation

final class PromoSummaryViewController: UIViewController, PromoPageInterface, PromoSummaryViewDelegate {
    weak var pageDelegate: PromoPageDelegate?
    
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
    }
    
    func promoSummary(promoSummary: PromoSummaryView, didTapLink link: PromoSlideshowLink) {
        logInfo("Did tap link \(link)")
    }
    
    func promoSummary(promoSummary: PromoSummaryView, didTapPlayForVideo video: PromoSlideshowOtherVideo) {
        logInfo("Did tap play video \(video)")
    }

    // MARK:- PromoPageInterface
    
    func didTapPlay() {}
    
    func didTapDismiss() {}
    
    func pageLostFocus() {
        logInfo("PromoSummary lost focus")
    }
    
    func pageGainedFocus() {
        logInfo("PromoSummary gained focus")
    }
}