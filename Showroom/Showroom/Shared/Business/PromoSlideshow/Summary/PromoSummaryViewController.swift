import Foundation

final class PromoSummaryViewController: UIViewController, PromoPageInterface {
    weak var pageDelegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, promoSlideshow: PromoSlideshow) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {}
    
    func didTapDismiss() {}
}