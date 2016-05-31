import Foundation
import RxSwift
import Decodable

class DashboardModel {
    let apiService: ApiService
    let userManager: UserManager
    let cacheManager: CacheManager
    
    init(apiService: ApiService, userManager: UserManager, cacheManager: CacheManager) {
        self.apiService = apiService
        self.userManager = userManager
        self.cacheManager = cacheManager
    }
    
    func fetchContentPromo() -> Observable<ContentPromoResult> {
        let diskCache: Observable<ContentPromoResult> = Observable.create { [unowned self] observer in
            do {
                guard let cachedData = try self.cacheManager.loadContentPromoResult() else {
                    logInfo("No cached content promo")
                    observer.onCompleted()
                    return NopDisposable.instance
                }
                logInfo("Received cached content promo \(cachedData)")
                observer.onNext(cachedData)
            } catch let error {
                observer.onError(error)
            }
            observer.onCompleted()
            return NopDisposable.instance
        }
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
        
        let network = apiService.fetchContentPromo(withGender: userManager.gender)
            .doOnNext { [unowned self] contentPromoResult in
                logInfo("Fetched content promos: \(contentPromoResult)")
                do {
                    logInfo("Saving content promos")
                    try self.cacheManager.saveContentPromoResult(contentPromoResult)
                } catch let exception {
                    logError("Error during saving content promos \(exception)")
                }
            }
            .observeOn(MainScheduler.asyncInstance)
        
        return Observable.of(diskCache, network).merge().distinctUntilChanged(==)
    }
}

extension CacheManager {
    func saveContentPromoResult(contentPromoResult: ContentPromoResult) throws {
        try save(withCacheName: Constants.Cache.contentPromoId, object: contentPromoResult)
    }
    func loadContentPromoResult() throws -> ContentPromoResult? {
        let contentPromoResult: ContentPromoResult? = try load(fromCacheName: Constants.Cache.contentPromoId)
        return contentPromoResult
    }
}