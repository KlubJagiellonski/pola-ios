import Foundation

final class VideoStepViewController: UIViewController, PromoPageInterface {
    weak var pageDelegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, link: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {}
    
    func didTapDismiss() {}
    
    func pageLostFocus() {
        logInfo("VideoStep lost focus")
    }
    
    func pageGainedFocus(shouldInvalidate shouldInvalidate: Bool) {
        logInfo("VideoStep gained focus")
    }
}