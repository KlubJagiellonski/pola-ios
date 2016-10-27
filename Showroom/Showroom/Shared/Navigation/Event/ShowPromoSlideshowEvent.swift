import Foundation

struct ShowPromoSlideshowEvent: NavigationEvent {
    let slideshowId: ObjectId
    let transitionImageTag: Int?
}
