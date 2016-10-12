import Foundation
import RxSwift
import Kingfisher

final class ProductStepPrefetcher: PromoSlideshowPagePrefetcher {
    var additionalData: AnyObject? = nil
    private let product: PromoSlideshowProduct
    
    init(data: PromoSlideshowPageData) {
        guard case let .Product(product, _) = data else {
            fatalError("Prefetcher created with from data \(data)")
        }
        self.product = product
    }
    
    func prefetch() -> Observable<AnyObject?> {
        let imageWidth = UIScreen.mainScreen().bounds.width
        let url = NSURL.createImageUrl(product.imageUrl, width: UIImageView.scaledImageSize(imageWidth) as Int)
        return ObservableUtils.prefetchImages(forUrls: [url]).flatMap { Observable.just(nil) }
    }
}