import Foundation

struct ShowSearchItemEvent: NavigationEvent {
    let searchItem: SearchItem
    let isMainItem: Bool
}
