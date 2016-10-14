import Foundation

typealias ProgressViewVisible = Bool

enum PromoPageViewState {
    case Close
    case Dismiss
    case FullScreen
    case Paused(ProgressViewVisible)
}

protocol PromoPageDelegate: class {
    func promoPage(promoPage: PromoPageInterface, didChangeCurrentProgress currentProgress: Double)
    func promoPageDidDownloadAllData(promoPage: PromoPageInterface)
    func promoPageDidFinished(promoPage: PromoPageInterface)
    func promoPage(promoPage: PromoPageInterface, willChangePromoPageViewState newViewState: PromoPageViewState, animationDuration: Double?)
}

protocol PromoPageInterface: class {
    var focused: Bool { get set }
    var shouldShowProgressViewInPauseState: Bool { get }
    weak var pageDelegate: PromoPageDelegate? { get set }
    
    func didTapPlay()
    func didTapDismiss()
}

// MARK:- Utilities

extension PromoPageViewState {
    var isPausedState: Bool {
        switch self {
        case .Paused(_): return true
        default: return false
        }
    }
    
    var isPausedProgressViewVisible: Bool? {
        switch self {
        case .Paused(let progressViewVisible): return progressViewVisible
        default: return nil
        }
    }
}

func ==(lhs:PromoPageViewState, rhs: PromoPageViewState) -> Bool {
    switch (lhs, rhs) {
    case (.Close, .Close), (.Dismiss, .Dismiss), (.FullScreen, .FullScreen): return true
    case (.Paused(let lhsVisible), .Paused(let rhsVisible)) where lhsVisible == rhsVisible: return true
    default: return false
    }
}

func !=(lhs:PromoPageViewState, rhs: PromoPageViewState) -> Bool {
    return !(lhs == rhs)
}