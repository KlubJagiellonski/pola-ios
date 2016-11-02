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
    case Product(dataEntry: ProductStepDataEntry)
    case Summary(PromoSlideshow)
}

final class PromoSlideshowModel {
    private let apiService: ApiService
    private let storage: KeyValueStorage
    private(set) var slideshowId: Int
    private(set) var promoSlideshow: PromoSlideshow?
    private var prefetcher = PromoSlideshowPrefetcher()
    private let disposeBag = DisposeBag()
    var shouldShowPlayFeedback: Bool {
        let videoPauseStateCount: Int = storage.load(forKey: Constants.UserDefaults.videoPauseStateCount) ?? 0
        return videoPauseStateCount < 5 //we show play feedback only 5x first times when user goes to pause state
    }
    
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
        let currentTime = NSDate().timeIntervalSince1970
        
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
            .concat().distinctUntilChanged { [weak self] _, _ in
                return self?.promoSlideshow != nil // we don't handle updating promo slideshow, so when one already exist, we filtering out next ones
        }
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
                return Observable.create { [unowned self] observer in
                    self.prefetcher.prefetch(forPageIndex: index, withData: pageData) { prefetchResult in
                        switch prefetchResult {
                        case .Success:
                            logInfo("Prefetch success")
                            if let promoSlideshow = result.result() {
                                let loadingTime = NSDate().timeIntervalSince1970 - currentTime
                                logAnalyticsEvent(AnalyticsEventId.VideoFirstSlideLoaded(promoSlideshow.id, Int(loadingTime * 1000)))
                            }
                            observer.onNext(result)
                        case .Error(let error):
                            logInfo("Prefetch error \(error)")
                            observer.onNext(result)
                        case .AlreadyFetched: break
                        }
                    }
                    return AnonymousDisposable { [weak self] in
                        self?.prefetcher.stopPrefetcher(atPageIndex: index)
                    }
                }
        }
    }
    
    func prefetchData(forPageAtIndex index: Int) {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return
        }
        prefetcher.prefetch(forPageIndex: index, withData: pageData, resultHandler: nil)
    }
    
    func data(forPageIndex index: Int) -> PromoSlideshowPageDataContainer? {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return nil
        }
        let additionalData = prefetcher.takeAdditionalData(atPageIndex: index)
        prefetcher.stopPrefetcher(atPageIndex: index)
        return PromoSlideshowPageDataContainer(pageData: pageData, additionalData: additionalData)
    }
    
    func didShowPauseState() {
        let currentPlayFeedbackCount: Int = storage.load(forKey: Constants.UserDefaults.videoPauseStateCount) ?? 0
        storage.save(currentPlayFeedbackCount + 1, forKey: Constants.UserDefaults.videoPauseStateCount)
    }
    
    private func createPageData(forPageAtIndex index: Int) -> PromoSlideshowPageData? {
        guard let slideshow = promoSlideshow else {
            return nil
        }
        
        if let step = slideshow.video.steps[safe: index] {
            return PromoSlideshowPageData(fromStep: step, promoSlideshow: slideshow)
        } else {
            return .Summary(slideshow)
        }
    }
}

extension PromoSlideshowPageData {
    private init(fromStep step: PromoSlideshowVideoStep, promoSlideshow: PromoSlideshow) {
        switch step.type {
        case .Image:
            self = .Image(link: step.link!, duration: step.duration)
        case .Video:
            self = .Video(link: step.link!, annotations: step.annotations)
        case .Product:
            self = .Product(dataEntry: ProductStepDataEntry(videoId: promoSlideshow.id, product: step.product!, duration: step.duration))
        }
    }
}
