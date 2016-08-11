import Foundation

struct ShowSettingsWebViewEvent: NavigationEvent {
    let title: String
    let webType: SettingsWebType
}