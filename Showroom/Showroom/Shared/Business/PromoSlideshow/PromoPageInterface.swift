import Foundation

enum PromoPageViewState {
    case Close
    case Dismiss
    case FullScreen
    case Paused
}

protocol PromoPageDelegate: class {
    func promoPage(promoPage: PromoPageInterface, didChangeCurrentProgress currentProgress: Double)
    func promoPageDidDownloadAllData(promoPage: PromoPageInterface)
    func promoPageDidFinished(promoPage: PromoPageInterface)
    func promoPage(promoPage: PromoPageInterface, willChangePromoPageViewState newViewState: PromoPageViewState, animationDuration: Double?)
}

protocol PromoPageInterface: class {
    weak var pageDelegate: PromoPageDelegate? { get set }
    
    func pageLostFocus()
    func pageGainedFocus()
    func didTapPlay()
    func didTapDismiss()
}