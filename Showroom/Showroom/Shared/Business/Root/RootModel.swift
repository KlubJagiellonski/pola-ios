import Foundation

enum RootChildType {
    case Main
    case Login
    case PlatformSelection
    case Onboarding
    case Start
}

class RootModel {
    private let userManager: UserManager
    let apiService: ApiService
    let rateAppManager: RateAppManager
    let notificationManager: NotificationsManager
    let versionManager: VersionManager
    private let prefetchingManager: PrefetchingManager
    private let storage: KeyValueStorage
    private let configurationManager: ConfigurationManager
    
    var startChildType: RootChildType {
        if !configurationManager.shouldSkipPlatformSelection {
            return .PlatformSelection
        } else if !shouldSkipStartScreen {
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
        get { return storage.load(forKey: "userSeenPagingInAppOnboarding") ?? false }
        set {
            logInfo("userSeenPagingInAppOnboarding \(newValue)")
            storage.save(newValue, forKey: "userSeenPagingInAppOnboarding")
        }
    }
    
    var userSeenWishlistInAppOnboarding: Bool {
        get { return storage.load(forKey: "userSeenWishlistInAppOnboarding") ?? false }
        set {
            logInfo("userSeenWishlistInAppOnboarding \(newValue)")
            storage.save(newValue, forKey: "userSeenWishlistInAppOnboarding")
        }
    }
    
    var appStoreURL: NSURL? {
        return configurationManager.configuration?.appStoreURL
    }
    
    var shouldSelectGender: Bool {
        return (configurationManager.configuration?.availableGenders.count > 1) ?? false
    }
    
    init(with userManager: UserManager, apiService: ApiService, rateAppManager: RateAppManager, notificationManager: NotificationsManager, versionManager: VersionManager, prefetchingManager: PrefetchingManager, storage: KeyValueStorage, configurationManager: ConfigurationManager) {
        self.userManager = userManager
        self.apiService = apiService
        self.rateAppManager = rateAppManager
        self.notificationManager = notificationManager
        self.versionManager = versionManager
        self.prefetchingManager = prefetchingManager
        self.storage = storage
        self.configurationManager = configurationManager
    }
    
    func willShowInitialOnboarding() {
        prefetchingManager.prefetchDashboard()
    }
}
