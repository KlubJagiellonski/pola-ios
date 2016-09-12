import Foundation
import RxSwift
import Decodable

extension Observable where Element: Decodable {
    static func retrieveFromCache(cacheId: String, storageManager: StorageManager) -> Observable<Element> {
        return Observable<Element>.create { observer in
            do {
                guard let cachedData: Element = try storageManager.loadFromCache(cacheId) else {
                    logInfo("No cache for cacheId: \(cacheId)")
                    observer.onCompleted()
                    return NopDisposable.instance
                }
                observer.onNext(cachedData)
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return NopDisposable.instance
        }
    }
}

extension ObservableType where E: Encodable {
    func save(cacheId: String, storageManager: StorageManager) -> Observable<E> {
        return doOnNext { result in
            do {
                try storageManager.save(cacheId, object: result)
            } catch {
                logError("Error during saving persistent data \(cacheId): \(error)")
            }
        }
    }
    
    func saveToCache(cacheId: String, storageManager: StorageManager) -> Observable<E> {
        return doOnNext { result in
            do {
                try storageManager.saveToCache(cacheId, object: result)
            } catch {
                logError("Error during caching \(cacheId): \(error)")
            }
        }
    }
}