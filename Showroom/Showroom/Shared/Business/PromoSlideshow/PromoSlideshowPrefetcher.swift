import Foundation
import RxSwift

protocol PromoSlideshowPagePrefetcher {
    var additionalData: AnyObject? { get }
    
    init(data: PromoSlideshowPageData)
    
    func prefetch() -> Observable<AnyObject?>
}

private struct OngoingPrefetchersInfo {
    let prefetcher: PromoSlideshowPagePrefetcher
    let disposable: Disposable
}

enum PromoSlideshowPrefetchResult {
    case Success
    case AlreadyFetched
    case Error(ErrorType)
}

final class PromoSlideshowPrefetcher {
    private var pageAlreadyPrefetched: [Int] = []
    private var additionalPrefetchedData: [Int: AnyObject] = [:]
    private var currentPrefetchersToPageMap: [Int: OngoingPrefetchersInfo] = [:]
    
    deinit {
        currentPrefetchersToPageMap.forEach { $1.disposable.dispose() }
        currentPrefetchersToPageMap.removeAll()
    }
    
    func prefetch(forPageIndex index: Int, withData data: PromoSlideshowPageData, resultHandler: (PromoSlideshowPrefetchResult -> Void)?) {
        guard !pageAlreadyPrefetched.contains(index) else {
            logInfo("Page already prefetched \(index)")
            resultHandler?(.AlreadyFetched)
            return
        }
        
        pageAlreadyPrefetched.append(index)
        
        createAndStartPrefetcher(forPageIndex: index, data: data, resultHandler: resultHandler)
    }
    
    func takeAdditionalData(atPageIndex index: Int) -> AnyObject? {
        return additionalPrefetchedData.removeValueForKey(index) ?? currentPrefetchersToPageMap[index]?.prefetcher.additionalData
    }
    
    func stopPrefetcher(atPageIndex index: Int) {
        if let info = currentPrefetchersToPageMap[index] {
            info.disposable.dispose()
        }
        currentPrefetchersToPageMap.removeValueForKey(index)
    }
    
    private func createAndStartPrefetcher(forPageIndex page: Int, data: PromoSlideshowPageData, resultHandler: (PromoSlideshowPrefetchResult -> Void)?) {
        let prefetcher = data.createPrefetcher()
        let disposable = prefetcher.prefetch().subscribe { [weak self] (event: Event<AnyObject?>) in
            guard let `self` = self else { return }
            
            switch event {
            case .Next(let additionalData):
                logInfo("Success in loading data \(page), \(data)")
                if let additionalData = additionalData {
                    self.additionalPrefetchedData[page] = additionalData
                }
                resultHandler?(.Success)
            case .Error(let error):
                logInfo("Could not prefetch data \(page), \(data), \(error)")
                resultHandler?(.Error(error))
            case .Completed:
                self.currentPrefetchersToPageMap.removeValueForKey(page)
            }
        }
        currentPrefetchersToPageMap[page] = OngoingPrefetchersInfo(prefetcher: prefetcher, disposable: disposable)
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