import Foundation
import RxSwift
import Decodable
import Haneke

class DashboardModel {
    private let apiService: ApiService
    private let emarsysService: EmarsysService
    private let userManager: UserManager
    private let storageManager: StorageManager
    let state = DashboardModelState()
    
    init(apiService: ApiService, userManager: UserManager, storageManager: StorageManager, emarsysService: EmarsysService) {
        self.apiService = apiService
        self.userManager = userManager
        self.storageManager = storageManager
        self.emarsysService = emarsysService
    }
    
    func fetchContentPromo() -> Observable<FetchCacheResult<ContentPromoResult>> {
        let existingResult = state.contentPromoResult
        let memoryCache: Observable<ContentPromoResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<ContentPromoResult> = Observable.retrieveFromCache(Constants.Cache.contentPromoId, storageManager: storageManager)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = apiService.fetchContentPromo(withGender: userManager.gender)
            .saveToCache(Constants.Cache.contentPromoId, storageManager: storageManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .merge().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in self?.state.contentPromoResult = result.result() }
    }
    
    func fetchRecommendations() -> Observable<FetchCacheResult<ProductRecommendationResult>> {
        let existingResult = state.recommendationsResult
        let memoryCache: Observable<ProductRecommendationResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<ProductRecommendationResult> = Observable.retrieveFromCache(Constants.Cache.productRecommendationsId, storageManager: storageManager)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = emarsysService.fetchProductRecommendations()
            .saveToCache(Constants.Cache.productRecommendationsId, storageManager: storageManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .merge().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in self?.state.recommendationsResult = result.result() }
    }
    
    func createProductDetailsContext(forRecommendation recommendation: ProductRecommendation, withImageWidth imageWidth: CGFloat) -> ProductDetailsContext {
        let recommendations = state.recommendationsResult!.productRecommendations
        let index = recommendations.indexOf(recommendation)!
        let productInfos: [ProductInfo] = recommendations.map { productRecommendation in
            let lowResImageUrl = NSURL.createImageUrl(productRecommendation.imageUrl, w: imageWidth, h: nil)
            return ProductInfo.Object(productRecommendation.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
        }
        return OnePageProductDetailsContext(productInfos: productInfos, initialProductIndex: index) { [weak self] index in
            self?.state.recommendationsIndex = index
        }
    }
}

class DashboardModelState {
    let recommendationsResultObservable = PublishSubject<ProductRecommendationResult?>()
    let contentPromoObservable = PublishSubject<ContentPromoResult?>()
    let recommendationsIndexObservable = PublishSubject<Int>()
    
    var recommendationsResult: ProductRecommendationResult? {
        didSet { recommendationsResultObservable.onNext(recommendationsResult) }
    }
    var contentPromoResult: ContentPromoResult? {
        didSet { contentPromoObservable.onNext(contentPromoResult) }
    }
    var recommendationsIndex: Int = 0 {
        didSet { recommendationsIndexObservable.onNext(recommendationsIndex) }
    }
}