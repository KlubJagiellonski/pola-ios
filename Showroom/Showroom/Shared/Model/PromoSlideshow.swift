import Foundation

struct PromoSlideshow {
    let brand: Brand
    let video: PromoSlideshowVideo
    let otherVideos: [PromoSlideshowOtherVideo]
    let links: [PromoSlideshowLink]
}

struct PromoSlideshowVideo {
    let steps: [PromoSlideshowVideoStep]
    let duration: Int
}

enum PromoSlideshowVideoStepType {
    case Video, Image, Product
}

struct PromoSlideshowVideoStep {
    let type: PromoSlideshowVideoStepType
    let link: String?
    let duration: Int
    let annotations: [PromoSlideshowVideoAnnotation]
    let product: PromoSlideshowProduct?
}

struct PromoSlideshowOtherVideo {
    let id: ObjectId
    let imageUrl: String
    let caption: PromoSlideshowOtherVideoCaption
}

struct PromoSlideshowLink {
    let text: String
    let link: String
}

struct PromoSlideshowOtherVideoCaption {
    let title: String
    let subtitle: String
    let color: PromoSlideshowOtherVideoCaptionColor
}

enum PromoSlideshowOtherVideoCaptionColor: String {
    case White = "white"
    case Black = "black"
}

struct PromoSlideshowVideoAnnotation {
    let style: PromoSlideshowVideAnnotationType
    let text: String
    let verticalPosition: Double
    let startTime: Double
    let duration: Double
}

enum PromoSlideshowVideAnnotationType: String {
    case White = "white"
    case Black = "black"
}

struct PromoSlideshowProduct {
    let id: ObjectId
    let brand: Brand
    let name: String
    let basePrice: Money
    let price: Money
    let imageUrl: String
}