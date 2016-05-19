import Foundation

enum RootChildType {
    case Main
    case Login
    case Onboarding
}

class RootModel {
    var startChildType: RootChildType {
        return .Main
    }
}