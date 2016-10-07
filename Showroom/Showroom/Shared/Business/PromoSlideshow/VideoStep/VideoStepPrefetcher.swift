import Foundation
import RxSwift

final class VideoStepPrefetcher: PromoSlideshowPagePrefetcher {
    init(data: PromoSlideshowPageData) {
        
    }
    
    func prefetch() -> Observable<AnyObject?> {
        //TODO: add prefetching video
        return Observable.just(nil)
    }
}