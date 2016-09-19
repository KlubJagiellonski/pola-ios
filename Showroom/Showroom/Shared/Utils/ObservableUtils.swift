import Foundation
import RxSwift
import Decodable

extension Observable where Element: Decodable {
    static func load(forKey key: String, storage: KeyValueStorage, type: StorageType) -> Observable<Element> {
        return Observable<Element>.create { observer in
            guard let cachedData: Element = storage.load(forKey: key, type: type) else {
                logInfo("No cache for cacheId: \(key), type \(type)")
                observer.onCompleted()
                return NopDisposable.instance
            }
            observer.onNext(cachedData)
            observer.onCompleted()
            return NopDisposable.instance
        }
    }
}

extension ObservableType where E: Encodable {
    func save(forKey key: String, storage: KeyValueStorage, type: StorageType) -> Observable<E> {
        return doOnNext { result in
            if !storage.save(result, forKey: key, type: type) {
                logError("Error during saving persistent data \(key), type \(type)")
            }
        }
    }
}