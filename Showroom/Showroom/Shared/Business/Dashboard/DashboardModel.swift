import Foundation
import RxSwift
import Decodable

enum FetchCacheResult<T: Equatable> {
    case Success(T)
    case CacheError(ErrorType)
    case NetworkError(ErrorType)
}

class DashboardModel {
    let apiService: ApiService
    let emarsysService: EmarsysService
    let userManager: UserManager
    let cacheManager: CacheManager
    
    init(apiService: ApiService, userManager: UserManager, cacheManager: CacheManager, emarsysService: EmarsysService) {
        self.apiService = apiService
        self.userManager = userManager
        self.cacheManager = cacheManager
        self.emarsysService = emarsysService
    }
    
    func fetchContentPromo() -> Observable<FetchCacheResult<ContentPromoResult>> {
        let diskCache: Observable<FetchCacheResult<ContentPromoResult>> = Observable.retrieveFromCache(Constants.Cache.contentPromoId, cacheManager: cacheManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
        
        let network = apiService.fetchContentPromo(withGender: userManager.gender)
            .saveToCache(Constants.Cache.contentPromoId, cacheManager: cacheManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
            .observeOn(MainScheduler.instance)
        
        return Observable.of(diskCache, network).merge().distinctUntilChanged(==)
    }
    
    func fetchRecommendations() -> Observable<FetchCacheResult<ProductRecommendationResult>> {
        let diskCache: Observable<FetchCacheResult<ProductRecommendationResult>> = Observable.retrieveFromCache(Constants.Cache.productRecommendationsId, cacheManager: cacheManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
        
        let network = emarsysService.fetchProductRecommendations()
            .saveToCache(Constants.Cache.productRecommendationsId, cacheManager: cacheManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
            .observeOn(MainScheduler.asyncInstance)
        
        return Observable.of(diskCache, network).merge().distinctUntilChanged(==)
    }
}

// MARK: - Equatable
extension FetchCacheResult: Equatable {}

func ==<T: Equatable>(lhs: FetchCacheResult<T>, rhs: FetchCacheResult<T>) -> Bool
{
    if case let FetchCacheResult.Success(lhsResult) = lhs {
        if case let FetchCacheResult.Success(rhsResult) = rhs {
            return lhsResult == rhsResult
        }
    }
    return false
}