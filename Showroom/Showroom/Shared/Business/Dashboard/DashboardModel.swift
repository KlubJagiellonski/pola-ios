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
    
    func fetchContentPromo() -> Observable<[ContentPromo]> {
        let diskCache: Observable<[ContentPromo]> = Observable.create { [unowned self] observer in
            do {
                guard let cachedData = try self.cacheManager.loadContentPromos() else {
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
        
        let network = apiService.fetchContentPromo(withGender: userManager.gender)
            .doOnNext { [unowned self] contentPromos in
                logInfo("Fetched content promos: \(contentPromos)")
                do {
                    logInfo("Saving content promos")
                    try self.cacheManager.saveContentPromos(contentPromos)
                } catch let exception {
                    logError("Error during saving content promos \(exception)")
                }
            }
        
        return Observable.of(diskCache, network).merge().distinctUntilChanged(==)
    }
}

extension CacheManager {
    func saveContentPromos(contentPromos: [ContentPromo]) throws {
        try save(withCacheName: Constants.Cache.contentPromoId, object: ContentPromoList(contentPromos: contentPromos))
    }
    func loadContentPromos() throws -> [ContentPromo]? {
        let contentPromoList: ContentPromoList? = try load(fromCacheName: Constants.Cache.contentPromoId)
        return contentPromoList?.contentPromos
    }
}

struct ContentPromoList: Encodable, Decodable {
    let contentPromos: [ContentPromo]
    
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for contentPromo in contentPromos {
            encodedList.addObject(contentPromo.encode())
        }
        let dict: NSDictionary = [
            "list": encodedList
        ]
        return dict
    }
    
    static func decode(json: AnyObject) throws -> ContentPromoList {
        let contentPromos: [ContentPromo] = try json => "list"
        return ContentPromoList(contentPromos: contentPromos)
    }
}