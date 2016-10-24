import Foundation
import RxSwift
import Kingfisher

final class PrefetchingManager {
    private let recommendationPrefetchImageLimit = 4
    
    private let api: ApiService
    private let storage: KeyValueStorage
    private var contentPromoPrefetcher: DataPrefetcher<ContentPromoResult>?
    private var recommendationsPrefetcher: DataPrefetcher<ProductRecommendationResult>?
    
    init(api: ApiService, storage: KeyValueStorage) {
        self.api = api
        self.storage = storage
    }
    
    func prefetchDashboard() {
        logInfo("Starting dashboard prefetch")
        contentPromoPrefetcher = DataPrefetcher(storage: storage, cacheId: Constants.Cache.contentPromoId, dataObservable: self.api.fetchContentPromo(withGender: .Female)) { [weak self] result in
            guard let `self` = self else { return [] }
            
            var urls: [NSURL] = []
            for (index, contentPromo) in result.contentPromos.enumerate() {
                if index > self.recommendationPrefetchImageLimit {
                    break
                }
                let imageSize = UIImageView.scaledImageSize(Dimensions.contentPromoImageWidth)
                let url = NSURL.createImageUrl(contentPromo.image.url, width: imageSize)
                urls.append(url)
            }
            return urls
        }
        recommendationsPrefetcher = DataPrefetcher(storage: storage, cacheId: Constants.Cache.productRecommendationsId, dataObservable: self.api.fetchProductRecommendations()) { result in
            var urls: [NSURL] = []
            for recommendation in result.productRecommendations {
                let imageSize = UIImageView.scaledImageSize(Dimensions.recommendationItemSize.width)
                let url = NSURL.createImageUrl(recommendation.imageUrl, width: imageSize)
                urls.append(url)
            }
            return urls
        }
        
        contentPromoPrefetcher?.start()
        recommendationsPrefetcher?.start()
    }
    
    func takeCachedDashboard(forGender gender: Gender) -> (ContentPromoResult?, ProductRecommendationResult?) {
        let contentPromoResult = contentPromoPrefetcher?.takeResult()
        let recommendationsResult = recommendationsPrefetcher?.takeResult()
        contentPromoPrefetcher = nil
        recommendationsPrefetcher = nil
        
        logInfo("Taking dashboard result. Exist? \(contentPromoResult != nil) \(recommendationsResult != nil)")
        
        if gender == .Female { // for now we are caching only for female
            return (contentPromoResult, recommendationsResult)
        } else {
            if !storage.remove(forKey: Constants.Cache.contentPromoId, type: .Cache) {
                logError("Cannot remove from cache")
            }
            return (nil, recommendationsResult)
        }
    }
}

private class DataPrefetcher<T: Encodable> {
    private let storage: KeyValueStorage
    private let cacheId: String
    private let dataObservable: Observable<T>
    private let retrieveUrlsBlock: T -> [NSURL]
    
    private var disposable: Disposable?
    private var result: T?
    private var imagePrefetcher: ImagePrefetcher?
    
    init(storage: KeyValueStorage, cacheId: String, dataObservable: Observable<T>, retrieveUrlsBlock: T -> [NSURL]) {
        self.storage = storage
        self.cacheId = cacheId
        self.dataObservable = dataObservable
        self.retrieveUrlsBlock = retrieveUrlsBlock
    }
    
    func start() {
        disposable = Observable<Void>.create { [unowned self] observer in
            let disposable = self.dataObservable
                .save(forKey: self.cacheId, storage: self.storage, type: .Cache)
                .subscribe { [weak self](event: Event<T>) in
                    guard let `self` = self else { return }
                    
                    logInfo("Prefetched \(self.cacheId). Starting to prefetch images")
                    
                    switch event {
                    case .Next(let result):
                        self.result = result
                        self.prefetchImages(with: observer, result: result)
                    case .Error(let error): observer.onError(error)
                    case .Completed: break
                    }
            }
            return AnonymousDisposable { [weak self] in
                logInfo("Disposing prefetching content promo")
                disposable.dispose()
                self?.imagePrefetcher?.stop()
                self?.imagePrefetcher = nil
            }
        }.subscribeNext { [weak self] in
            logInfo("Data prefetch \(self?.cacheId) completed")
        }
    }
    
    func takeResult() -> T? {
        disposable?.dispose()
        disposable = nil
        return result
    }
    
    private func prefetchImages(with observer: AnyObserver<Void>, result: T) {
        let urls: [NSURL] = retrieveUrlsBlock(result)
        
        let progressBlock: Kingfisher.PrefetcherProgressBlock = {
            [weak self](skippedResources: [Kingfisher.Resource], failedResources: [Kingfisher.Resource], completedResources: [Kingfisher.Resource]) in
            logInfo("Prefetching images for \(self?.cacheId) in progress skippedResources \(skippedResources), failedResources \(failedResources), completedResources \(completedResources)")
        }
        
        let completionBlock: Kingfisher.PrefetcherCompletionHandler = {
            [weak self](skippedResources: [Kingfisher.Resource], failedResources: [Kingfisher.Resource], completedResources: [Kingfisher.Resource]) in
            logInfo("Prefetching images for \(self?.cacheId) finished")
            observer.onNext()
            observer.onCompleted()
            self?.imagePrefetcher = nil
        }
        
        logInfo("Starting prefetching for \(cacheId) with \(urls.count) images")
        
        imagePrefetcher = ImagePrefetcher(urls: urls, progressBlock: progressBlock, completionHandler: completionBlock)
        imagePrefetcher?.start()
    }
}
