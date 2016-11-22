import Foundation
import RxSwift
import CoreSpotlight
import MobileCoreServices

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
    private var searchIndexed: Bool {
        get {
            return storage.load(forKey: Constants.UserDefaults.searchableItemsAlreadyIndexed) ?? false
        }
        set {
            storage.save(newValue, forKey: Constants.UserDefaults.searchableItemsAlreadyIndexed)
        }
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
            .map { FetchCacheResult.Success($0, .Cache) }
            .catchError { Observable.just(FetchCacheResult.CacheError($0)) }
        
        let network = api.fetchSearchCatalogue()
            .save(forKey: Constants.Cache.searchCatalogueId, storage: storage, type: .Persistent)
            .map { FetchCacheResult.Success($0, .Network) }
            .catchError { Observable.just(FetchCacheResult.NetworkError($0)) }
        
        return Observable.of(cacheCompose, network)
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .merge().distinctUntilChanged(==)
            .doOnNext { [weak self]result in
                guard let `self` = self else { return }
                if case let FetchCacheResult.Success(data, sourceType) = result where sourceType == .Network || !self.searchIndexed {
                    self.updateSearchableIndex(withSearchResult: data)
                }
            }
            .observeOn(MainScheduler.instance)
            .doOnNext { [weak self]result in
                if let result = result.result() {
                    self?.searchResult = result
                }
        }
    }
    
    // MARK:- CSSearchableIndex
    
    private var isSearchableIndexSyncing = false
    
    private func updateSearchableIndex(withSearchResult result: SearchResult) {
        guard !isSearchableIndexSyncing else { return }
        
        isSearchableIndexSyncing = true
        
        let items = createSearchableItems(forSearchItems: result.rootItems, breadcrumb: "")
        
        let index = CSSearchableIndex.defaultSearchableIndex()
        let indexResult: (NSError?) -> () = { [weak self]error in
            guard let `self` = self else { return }
            
            self.isSearchableIndexSyncing = false
            if let error = error {
                logError("Could not index searchableItems \(error)")
                self.searchIndexed = false
            } else {
                logInfo("Indexed searchable items")
                self.searchIndexed = true
            }
        }
        let deleteResult: (NSError?) -> () = { [weak self]error in
            guard let `self` = self else { return }
            
            if let error = error {
                self.isSearchableIndexSyncing = false
                self.searchIndexed = false
                logError("Could not delete searchableItems \(error)")
            } else {
                logInfo("Deleted searchable items")
                index.indexSearchableItems(items, completionHandler: indexResult)
            }
        }
        index.deleteAllSearchableItemsWithCompletionHandler(deleteResult)
    }
    
    private func createSearchableItems(forSearchItems searchItems: [SearchItem], breadcrumb: String) -> [CSSearchableItem] {
        var items: [CSSearchableItem] = []
        for searchItem in searchItems {
            if let item = createSearchableItem(forSearchItem: searchItem, breadcrumb: breadcrumb) {
                items.append(item)
            }
            if let branchs = searchItem.branches {
                let itemBreadcrumb = breadcrumb.isEmpty ? searchItem.name : "\(breadcrumb) > \(searchItem.name)"
                items.appendContentsOf(createSearchableItems(forSearchItems: branchs, breadcrumb: itemBreadcrumb))
            }
        }
        return items
    }
    
    private func createSearchableItem(forSearchItem searchItem: SearchItem, breadcrumb: String) -> CSSearchableItem? {
        guard searchItem.link != nil else { return nil }
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
        attributeSet.title = searchItem.name
        attributeSet.contentDescription = breadcrumb
        
        return CSSearchableItem(uniqueIdentifier: searchItem.link, domainIdentifier: nil, attributeSet: attributeSet)
    }
}
