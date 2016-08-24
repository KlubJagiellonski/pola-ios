import Foundation

enum RootChildType {
    case Main
    case Login
    case Onboarding
    case Start
}

class RootModel {
    private let userManager: UserManager
    let apiService: ApiService
    let rateAppManager: RateAppManager
    let notificationManager: NotificationsManager
    
    var startChildType: RootChildType {
        if (!userManager.shouldSkipStartScreen) {
            return .Onboarding
        } else {
            return .Main
        }
    }
    
    var shouldSkipStartScreen: Bool {
        set { userManager.shouldSkipStartScreen = newValue }
        get { return userManager.shouldSkipStartScreen }
    }
    
    init(with userManager: UserManager, apiService: ApiService, rateAppManager: RateAppManager, notificationManager: NotificationsManager) {
        self.userManager = userManager
        self.apiService = apiService
        self.rateAppManager = rateAppManager
        self.notificationManager = notificationManager
    }
}