import Foundation

enum PromoPageViewState {
    
}

protocol PromoPageDelegate: class {
    func promoPage(promoPage: PromoPageInterface, didChangeCurrentProgress currentProgress: Double)
    func promoPageDidDownloadAllData(promoPage: PromoPageInterface)
    func promoPageDidFinished(promoPage: PromoPageInterface)
    func promoPage(promoPage: PromoPageInterface, willChangePromoPageViewState newViewState: PromoPageViewState, animationDuration: Double?)
}

protocol PromoPageInterface: class {
    weak var delegate: PromoPageDelegate? { get set }
}