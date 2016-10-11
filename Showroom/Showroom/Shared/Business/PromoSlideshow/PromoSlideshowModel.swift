import Foundation
import RxSwift

typealias DataLink = String

struct PromoSlideshowPageDataContainer {
    let pageData: PromoSlideshowPageData
    let additionalData: AnyObject?
}

enum PromoSlideshowPageData {
    case Image(link: DataLink, duration: Int)
    case Video(link: DataLink, annotations: [PromoSlideshowVideoAnnotation])
    case Product(product: PromoSlideshowProduct, duration: Int)
    case Summary(PromoSlideshow)
}

final class PromoSlideshowModel {
    private let apiService: ApiService
    private let storage: KeyValueStorage
    private var slideshowId: Int
    private(set) var promoSlideshow: PromoSlideshow?
    private var prefetcher = PromoSlideshowPrefetcher()
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService, storage: KeyValueStorage, slideshowId: Int) {
        self.apiService = apiService
        self.slideshowId = slideshowId
        self.storage = storage
    }
    
    func update(withSlideshowId slideshowId: ObjectId) {
        self.slideshowId = slideshowId
        self.prefetcher = PromoSlideshowPrefetcher()
        self.promoSlideshow = nil
    }
    
    func fetchPromoSlideshow() -> Observable<FetchCacheResult<PromoSlideshow>> {
        let cacheId = Constants.Cache.video + String(slideshowId)
        
        let existingResult = promoSlideshow
        let memoryCache: Observable<PromoSlideshow> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<PromoSlideshow> = Observable.load(forKey: cacheId, storage: storage, type: .Cache)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = apiService.fetchVideo(withVideoId: slideshowId)
            .save(forKey: cacheId, storage: storage, type: .Cache)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .concat().distinctUntilChanged( ==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let result = result.result() {
                    self?.promoSlideshow = result
                }
        }.flatMap { [weak self] result -> Observable<FetchCacheResult<PromoSlideshow>> in
                guard let `self` = self else {
                    return Observable.just(result)
                }
                guard self.promoSlideshow != nil else {
                    return Observable.just(result)
                }
                let index = 0
                let pageData = self.createPageData(forPageAtIndex: index)!
                let prefetchObservable = self.prefetcher.prefetch(forPageIndex: index, withData: pageData)
                return prefetchObservable.flatMap { (value: AnyObject?) -> Observable<FetchCacheResult<PromoSlideshow>> in
                    return Observable.just(result)
                }
        }
    }
    
    func prefetchData(forPageAtIndex index: Int) {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return
        }
        prefetcher.prefetch(forPageIndex: index, withData: pageData)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    func data(forPageIndex index: Int) -> PromoSlideshowPageDataContainer? {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return nil
        }
        let additionalData = prefetcher.additionalData(atPageIndex: index)
        return PromoSlideshowPageDataContainer(pageData: pageData, additionalData: additionalData)
    }
    
    private func createPageData(forPageAtIndex index: Int) -> PromoSlideshowPageData? {
        guard let slideshow = promoSlideshow else {
            return nil
        }
        
        if let step = slideshow.video.steps[safe: index] {
            return PromoSlideshowPageData(fromStep: step)
        } else {
            return .Summary(slideshow)
        }
    }
}

extension PromoSlideshowPageData {
    private init(fromStep step: PromoSlideshowVideoStep) {
        switch step.type {
        case .Image:
            self = .Image(link: step.link!, duration: step.duration)
        case .Video:
            self = .Video(link: step.link!, annotations: step.annotations)
        case .Product:
            self = .Product(product: step.product!, duration: step.duration)
        }
    }
}