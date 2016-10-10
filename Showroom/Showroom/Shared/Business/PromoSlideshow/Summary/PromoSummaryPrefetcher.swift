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
        for playlistItem in promoSlideshow.playlist {
            let url = NSURL.createImageUrl(playlistItem.imageUrl, width: UIImageView.scaledImageSize(imageWidth) as Int)
            urls.append(url)
        }
        return ObservableUtils.prefetchImages(forUrls: urls).flatMap { Observable.just(nil) }
    }
}