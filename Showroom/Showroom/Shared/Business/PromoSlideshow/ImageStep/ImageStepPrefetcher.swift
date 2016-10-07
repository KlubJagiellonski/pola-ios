import Foundation
import RxSwift
import Kingfisher

final class ImageStepPrefetcher: PromoSlideshowPagePrefetcher {
    private let link: String
    
    init(data: PromoSlideshowPageData) {
        guard case let .Image(link, _) = data else {
            fatalError("Prefetcher created with from data \(data)")
        }
        self.link = link
    }
    
    func prefetch() -> Observable<AnyObject?> {
        let imageWidth = UIScreen.mainScreen().bounds.width
        let url = NSURL.createImageUrl(link, width: UIImageView.scaledImageSize(imageWidth) as Int)
        return ObservableUtils.prefetchImages(forUrls: [url]).flatMap { Observable.just(nil) }
    }
}