import Foundation
import RxSwift

final class SearchModel {
    private let api: ApiService
    private let storage: KeyValueStorage
    private let userManager: UserManager
    
    private(set) var searchResult: SearchResult?
    var userGender: Gender {
        return userManager.gender
    }
    var genderObservable: Observable<Gender> {
        return userManager.genderObservable
    }
    
    init(with api: ApiService, and storage: KeyValueStorage, and userManager: UserManager) {
        self.api = api
        self.storage = storage
        self.userManager = userManager
    }
    
    func fetchSearchItems() -> Observable<FetchCacheResult<SearchResult>> {
        let existingResult = searchResult
        let memoryCache: Observable<SearchResult> = existingResult == nil ? Observable.empty() : Observable.just(existingResult!)
        
        let diskCache: Observable<SearchResult> = Observable.load(forKey: Constants.Cache.searchCatalogueId, storage: storage, type: .Persistent)
            .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        
        let cacheCompose = Observable.of(memoryCache, diskCache)
            .concat().take(1)
            .map { FetchCacheResult.Success($0) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = api.fetchSearchCatalogue()
            .save(forKey: Constants.Cache.searchCatalogueId, storage: storage, type: .Persistent)
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