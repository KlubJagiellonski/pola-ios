import Foundation

struct PromoSlideshow {
    let brand: Brand
    let video: PromoSlideshowVideo
    let otherVideos: [PromoSlideshowOtherVideo]
    let links: [PromoSlideshowLink]
}

struct PromoSlideshowVideo {
    let steps: [PromoSlideshowVideoStep]
    let duration: Double
}

enum PromoSlideshowVideoStepType {
    case Video, Image, Product
}

struct PromoSlideshowVideoStep {
    let type: PromoSlideshowVideoStepType
    let link: String
    let duration: Double
}

struct PromoSlideshowOtherVideo {
    let imageUrl: String
    let link: String
}

struct PromoSlideshowLink {
    let text: String
    let link: String
}