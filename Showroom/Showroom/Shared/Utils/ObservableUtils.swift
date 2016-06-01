import Foundation
import RxSwift
import Decodable

extension Observable where Element: Decodable {
    static func retrieveFromCache(cacheId: String, cacheManager: CacheManager) -> Observable<Element> {
        return Observable<Element>.create { observer in
            do {
                guard let cachedData: Element = try cacheManager.load(fromCacheName: cacheId) else {
                    logInfo("No cache for cacheId: \(cacheId)")
                    observer.onCompleted()
                    return NopDisposable.instance
                }
                logInfo("Received cached for \(cacheId): \(cachedData)")
                observer.onNext(cachedData)
            } catch let error {
                observer.onError(error)
            }
            observer.onCompleted()
            return NopDisposable.instance
        }
    }
}

extension ObservableType where E: Encodable {
    func saveToCache(cacheId: String, cacheManager: CacheManager) -> Observable<E> {
        return doOnNext { result in
            do {
                logInfo("Saving cache \(cacheId): \(result)")
                try cacheManager.save(withCacheName: cacheId, object: result)
            } catch let exception {
                logError("Error during caching \(cacheId): \(exception)")
            }
        }
    }
}