import Foundation

enum RootChildType {
    case Main
    case Login
    case Onboarding
    case Start
}

class RootModel {
    private let resolver: DiResolver
    private let userManager: UserManager
    
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
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        self.userManager = resolver.resolve(UserManager.self)
    }
}