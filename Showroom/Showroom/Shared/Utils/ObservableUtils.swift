import Foundation
import RxSwift
import Decodable
import Kingfisher

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

final class ObservableUtils {
    static func prefetchImages(forUrls urls: [NSURL]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            let completionHandler = {
                (skippedResources: [Kingfisher.Resource], failedResources: [Kingfisher.Resource], completedResources: [Kingfisher.Resource]) -> () in
                logInfo("Result, skipped: \(skippedResources), failed: \(failedResources), completed \(completedResources)")
                observer.onNext()
                observer.onCompleted()
            }
            
            let imagePrefetcher = ImagePrefetcher(urls: urls, completionHandler: completionHandler)
            imagePrefetcher.start()
            
            return AnonymousDisposable() {
                imagePrefetcher.stop()
            }
        }
    }

}