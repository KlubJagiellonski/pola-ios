import Foundation
import RxSwift
import Decodable

class DashboardModel {
    private let disposeBag = DisposeBag()
    private let apiService: ApiService
    private let userManager: UserManager
    private let storage: KeyValueStorage
    private let prefetchingManager: PrefetchingManager
    private var takeOnlyCachedRecommendations = false
    let triggerFetchContentPromoObservable: Observable<Void> = PublishSubject()
    let state = DashboardModelState()
    
    init(apiService: ApiService, userManager: UserManager, storage: KeyValueStorage, prefetchingManager: PrefetchingManager) {
        self.apiService = apiService
        self.userManager = userManager
        self.storage = storage
        self.prefetchingManager = prefetchingManager
        
        let (contentPromoResult, recommendationsResult) = prefetchingManager.takeCachedDashboard(forGender: userManager.gender)
        if recommendationsResult != nil {
            state.recommendationsResult = recommendationsResult
            takeOnlyCachedRecommendations = true
        }
        if contentPromoResult != nil {
            state.contentPromoResult = contentPromoResult
        }
        
        userManager.genderObservable.subscribeNext { [weak self] gender in
            guard let `self` = self else { return }
            self.storage.remove(forKey: Constants.Cache.contentPromoId, type: .Persistent)
            self.state.contentPromoResult = nil
            (self.triggerFetchContentPromoObservable as! PublishSubject).onNext()
        }.addDisposableTo(disposeBag)
    }
    
    func fetchContentPromo() -> Observable<FetchCacheResult<ContentPromoResult>> {
        let existingResult = state.contentPromoResult
        let memoryCache: Observable<ContentPromoResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<ContentPromoResult> = Observable.load(forKey: Constants.Cache.contentPromoId, storage: storage, type: .Persistent)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0, .Cache) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = apiService.fetchContentPromo(withGender: userManager.gender)
            .save(forKey: Constants.Cache.contentPromoId, storage: storage, type: .Persistent)
            .map { FetchCacheResult.Success($0, .Network) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .concat().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let result = result.result() {
                    self?.state.contentPromoResult = result
                }
        }
    }
    
    func fetchRecommendations() -> Observable<FetchCacheResult<ProductRecommendationResult>> {
        let existingResult = state.recommendationsResult
        let memoryCache: Observable<ProductRecommendationResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<ProductRecommendationResult> = Observable.load(forKey: Constants.Cache.productRecommendationsId, storage: storage, type: .Persistent)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0, .Cache) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = apiService.fetchProductRecommendations()
            .save(forKey: Constants.Cache.productRecommendationsId, storage: storage, type: .Persistent)
            .map { FetchCacheResult.Success($0, .Network) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        let observable = takeOnlyCachedRecommendations ? Observable.of(cacheCompose) : Observable.of(cacheCompose, network)
        takeOnlyCachedRecommendations = false
        return observable
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .merge().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let result = result.result() {
                    self?.state.recommendationsResult = result
                }
        }
    }
    
    func createProductDetailsContext(forRecommendation recommendation: ProductRecommendation, withImageWidth imageWidth: Int) -> ProductDetailsContext {
        let recommendations = state.recommendationsResult!.productRecommendations
        let index = recommendations.indexOf(recommendation)!
        
        self.state.recommendationsIndex = index
        let onChanged = { [unowned self] (index: Int) -> () in
            logInfo("Changed recommendation to index \(index)")
            self.state.updateRecommendationsIndexWithNotyfingObserver(with: index)
        }
        
        let onRetrieveProductInfo = { [unowned self] (index: Int) -> ProductInfo in
            guard let recommendations = self.state.recommendationsResult?.productRecommendations else {
                fatalError("Cannot create product info when there is no product recommendations")
            }
            let productRecommendation = recommendations[index]
            let lowResImageUrl = NSURL.createImageUrl(productRecommendation.imageUrl, width: imageWidth, height: nil)
            let info = ProductInfo.Object(productRecommendation.toProduct(withLowResImageUrl: lowResImageUrl.absoluteString))
            logInfo("Retrieve product info \(info)")
            return info
        }
        
        return OnePageProductDetailsContext(productsCount: recommendations.count, initialProductIndex: index, fromType: .HomeRecommendation, onChanged: onChanged, onRetrieveProductInfo: onRetrieveProductInfo)
    }
}

class DashboardModelState {
    let recommendationsResultObservable = PublishSubject<ProductRecommendationResult?>()
    let contentPromoObservable = PublishSubject<ContentPromoResult?>()
    let recommendationsIndexObservable = PublishSubject<Int?>()
    
    var recommendationsResult: ProductRecommendationResult? {
        didSet { recommendationsResultObservable.onNext(recommendationsResult) }
    }
    var contentPromoResult: ContentPromoResult? {
        didSet { contentPromoObservable.onNext(contentPromoResult) }
    }
    private(set) var recommendationsIndex: Int?
    func updateRecommendationsIndexWithNotyfingObserver(with index: Int?) {
        recommendationsIndex = index
        recommendationsIndexObservable.onNext(recommendationsIndex)
    }
}
