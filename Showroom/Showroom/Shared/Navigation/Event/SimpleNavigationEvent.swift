import Foundation

struct SimpleNavigationEvent: NavigationEvent {
    let type: Type
    
    enum Type {
        case Back
        case Close
        case CloseImmediately // same as Close but forcing to close as fast as possible (without animation)
        case ShowCountrySelectionList
        case ShowCheckoutSummary
        case ShowSearch
        case ShowLogin
        case ShowRegistration
        case ShowResetPassword
        case ShowDashboard
        case SplashEnd
        case ShowFilteredProducts
        case OnboardingEnd
        case ShowHistoryOfOrder
        case ProductAddedToBasket
        case ShowEditAddress
        case ShowOnboarding
        case ShowRules
        case AskForNotificationsFromWishlist
        case ShowProductDetailsInAppOnboarding
        case ShowProductListInAppOnboarding
        case ShowSettingsPlatformSelection
        case ShowInitialPlatformSelection
        case PlatformSelectionEnd
    }
}