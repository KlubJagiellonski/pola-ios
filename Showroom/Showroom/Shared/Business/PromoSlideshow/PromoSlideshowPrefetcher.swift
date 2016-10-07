import Foundation
import RxSwift

protocol PromoSlideshowPagePrefetcher {
    init(data: PromoSlideshowPageData)
    
    func prefetch() -> Observable<AnyObject?>
}

final class PromoSlideshowPrefetcher {
    private var pageAlreadyPrefetched: [Int] = []
    private var additionalPrefetchedData: [Int: AnyObject] = [:]
    
    func prefetch(forPageIndex index: Int, withData data: PromoSlideshowPageData) -> Observable<AnyObject?>{
        guard !pageAlreadyPrefetched.contains(index) else {
            logInfo("Page already prefetched \(index)")
            return Observable.just(nil)
        }
        
        pageAlreadyPrefetched.append(index)
        
        return createAndStartPrefetcher(forPageIndex: index, data: data)
    }
    
    func additionalData(atPageIndex index: Int) -> AnyObject? {
        return additionalPrefetchedData[index]
    }
    
    private func createAndStartPrefetcher(forPageIndex page: Int, data: PromoSlideshowPageData) -> Observable<AnyObject?> {
        let prefetcher = data.createPrefetcher()
        return prefetcher.prefetch().doOn { [weak self] (event: Event<AnyObject?>) in
            guard let `self` = self else { return }
            
            switch event {
            case .Next(let additionalData):
                logInfo("Success in loading data \(page), \(data)")
                if let additionalData = additionalData {
                    self.additionalPrefetchedData[page] = additionalData
                }
            case .Error(_):
                logInfo("Could not prefetch data \(page), \(data)")
            default: break
            }
        }
    }
}

extension PromoSlideshowPageData {
    func createPrefetcher() -> PromoSlideshowPagePrefetcher {
        switch self {
        case .Image:
            return ImageStepPrefetcher(data: self)
        case .Product:
            return ProductStepPrefetcher(data: self)
        case .Video:
            return VideoStepPrefetcher(data: self)
        case .Summary:
            return PromoSummaryPrefetcher(data: self)
        }
    }
}