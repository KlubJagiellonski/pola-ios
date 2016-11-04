import Foundation

typealias ProgressViewVisible = Bool

enum PromoPageViewState {
    case Playing
    case PausedWithDetailContent
    case PausedWithFullscreenContent
    case Paused(ProgressViewVisible)
}

struct PromoPageState {
    let focused: Bool
    let playing: Bool
}

protocol PromoPageDelegate: class {
    func promoPage(promoPage: PromoPageInterface, didChangeCurrentProgress currentProgress: Double)
    func promoPageDidDownloadAllData(promoPage: PromoPageInterface)
    func promoPageDidFinished(promoPage: PromoPageInterface)
    func promoPage(promoPage: PromoPageInterface, willChangePromoPageViewState newViewState: PromoPageViewState, animationDuration: Double?)
}

protocol PromoPageInterface: class {
    // setting pageState = PromoPageState(focused: false, playing: true)
    // should update UI to playing state without playing content (pausing content might be necessary) 
    var pageState: PromoPageState { get set }
    var shouldShowProgressViewInPauseState: Bool { get }
    weak var pageDelegate: PromoPageDelegate? { get set }
    
    func didTapPlay()
    func didTapDismiss()
    func resetProgressState()
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
    
    var isPlayingState: Bool {
        switch self {
        case .Playing:
            return true
        case .PausedWithDetailContent, .PausedWithFullscreenContent, .Paused:
            return false
        }
    }
}

func ==(lhs:PromoPageViewState, rhs: PromoPageViewState) -> Bool {
    switch (lhs, rhs) {
    case (.Playing, .Playing), (.PausedWithDetailContent, .PausedWithDetailContent), (.PausedWithFullscreenContent, .PausedWithFullscreenContent): return true
    case (.Paused(let lhsVisible), .Paused(let rhsVisible)) where lhsVisible == rhsVisible: return true
    default: return false
    }
}

func !=(lhs:PromoPageViewState, rhs: PromoPageViewState) -> Bool {
    return !(lhs == rhs)
}
