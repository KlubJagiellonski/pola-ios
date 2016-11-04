import Foundation

struct ShowPromoSlideshowEvent: NavigationEvent {
    let entry: PromoSlideshowEntry
    let transitionImageTag: Int?
}
