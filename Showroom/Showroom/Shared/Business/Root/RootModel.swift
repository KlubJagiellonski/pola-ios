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
    let versionManager: VersionManager
    
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
    
    var userSeenPagingInAppOnboarding: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userSeenPagingInAppOnboarding") }
        set {
            logInfo("userSeenPagingInAppOnboarding \(newValue)")
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userSeenPagingInAppOnboarding")
        }
    }
    
    var userSeenWishlistInAppOnboarding: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey("userSeenWishlistInAppOnboarding") }
        set {
            logInfo("userSeenWishlistInAppOnboarding \(newValue)")
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "userSeenWishlistInAppOnboarding")
        }
    }
    
    init(with userManager: UserManager, apiService: ApiService, rateAppManager: RateAppManager, notificationManager: NotificationsManager, versionManager: VersionManager) {
        self.userManager = userManager
        self.apiService = apiService
        self.rateAppManager = rateAppManager
        self.notificationManager = notificationManager
        self.versionManager = versionManager
    }
}