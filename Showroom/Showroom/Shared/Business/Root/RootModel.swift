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
    
    var startChildType: RootChildType {
        if (!userManager.shouldSkipStartScreen) {
            return .Onboarding
        } else {
            return .Main
        }
    }
    
    var shouldSkipStartScreen: Bool {
        set { userManager.shouldSkipStartScreen = true }
        get { return userManager.shouldSkipStartScreen }
    }
    
    init(with userManager: UserManager, and apiService: ApiService) {
        self.userManager = userManager
        self.apiService = apiService
    }
}