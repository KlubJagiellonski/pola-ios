import Foundation

struct SimpleNavigationEvent: NavigationEvent {
    let type: Type
    
    enum Type {
        case Back
        case Close
        case ShowCountrySelectionList
        case ShowCheckoutSummary
        case ShowSearch
        case ShowLogin
        case ShowRegistration
        case ShowEditKiosk
        case ShowDashboard
        case SplashEnd
    }
}
