import Foundation
import RxSwift

final class SearchModel {
    private let api: ApiService
    private let storageManager: StorageManager
    private let userManager: UserManager
    
    private(set) var searchResult: SearchResult?
    var userGender: Gender {
        return userManager.gender
    }
    var genderObservable: Observable<Gender> {
        return userManager.genderObservable
    }
    
    init(with api: ApiService, and storageManager: StorageManager, and userManager: UserManager) {
        self.api = api
        self.storageManager = storageManager
        self.userManager = userManager
    }
    
    func fetchSearchItems() -> Observable<FetchCacheResult<SearchResult>> {
        let existingResult = searchResult
        let memoryCache: Observable<SearchResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<SearchResult> = Observable.retrieveFromCache(Constants.Cache.searchCatalogueId, storageManager: storageManager)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = api.fetchSearchCatalogue()
            .saveToCache(Constants.Cache.searchCatalogueId, storageManager: storageManager)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .merge().distinctUntilChanged(==)
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self] result in
                if let result = result.result() {
                    self?.searchResult = result
                }
        }
    }
}