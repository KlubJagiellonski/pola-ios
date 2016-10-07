import Foundation
import RxSwift

final class PromoSummaryPrefetcher: PromoSlideshowPagePrefetcher {
    private let promoSlideshow: PromoSlideshow
    
    init(data: PromoSlideshowPageData) {
        guard case let .Summary(promoSlideshow) = data else {
            fatalError("Prefetcher created with from data \(data)")
        }
        self.promoSlideshow = promoSlideshow
    }
    
    func prefetch() -> Observable<AnyObject?> {
        let imageWidth = UIScreen.mainScreen().bounds.width
        var urls: [NSURL] = []
        for otherVideo in promoSlideshow.otherVideos {
            let url = NSURL.createImageUrl(otherVideo.imageUrl, width: UIImageView.scaledImageSize(imageWidth) as Int)
            urls.append(url)
        }
        return ObservableUtils.prefetchImages(forUrls: urls).flatMap { Observable.just(nil) }
    }
}