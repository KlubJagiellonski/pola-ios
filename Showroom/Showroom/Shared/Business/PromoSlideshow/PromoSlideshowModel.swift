import Foundation
import RxSwift

typealias DataLink = String

struct PromoSlideshowPageDataContainer {
    let pageData: PromoSlideshowPageData
    let additionalData: AnyObject?
}

enum PromoSlideshowPageData {
    case Image(link: DataLink, duration: Int)
    case Video(DataLink)
    case Product(product: PromoSlideshowProduct, duration: Int)
    case Summary(PromoSlideshow)
}

final class PromoSlideshowModel {
    private var slideshowId: Int
    private(set) var promoSlideshow: PromoSlideshow?
    private let prefetcher = PromoSlideshowPrefetcher()
    private let disposeBag = DisposeBag()
    
    init(slideshowId: Int) {
        self.slideshowId = slideshowId
    }
    
    func update(withSlideshowId slideshowId: ObjectId) {
        self.slideshowId = slideshowId
        self.promoSlideshow = nil
    }
    
    func fetchPromoSlideshow() -> Observable<PromoSlideshow> {
        //TODO: real api
        let brand = Brand(id: 1234, name: "Test brand")
        //TODO: add correct test links
        let product = PromoSlideshowProduct(id: 78854, brand: Brand(id: 541, name: "gego"), name: "T-shirt Nie mów", basePrice: Money(amt: 70.0), price: Money(amt: 70.0), imageUrl: "https://assets.shwrm.net/images/0/4/0457e906540b2b0_500x643.jpg?1474889300")
        
        let steps = [
            PromoSlideshowVideoStep(type: .Video, link: "https://s3-eu-west-1.amazonaws.com/shwrm-video-test/logo_1.mp4", duration: 5000, annotations: [], product: nil),
            PromoSlideshowVideoStep(type: .Image, link: "https://assets.shwrm.net/media/update_grafika.jpg?1474968323", duration: 5000, annotations: [], product: nil),
            PromoSlideshowVideoStep(type: .Product, link: "", duration: 3000, annotations: [], product: product),
        ]
        let video = PromoSlideshowVideo(steps: steps, duration: steps.reduce(0, combine: { $0 + $1.duration }))
        
        let otherVideos = [
            PromoSlideshowOtherVideo(id: 123, imageUrl: "https://assets.shwrm.net/images/f/p/fp57c59e14baf5f.jpg?1472568852000", caption: PromoSlideshowOtherVideoCaption(title: "RÖCKE", subtitle: "Mini, Midi, Maxi", color: .Black)),
            PromoSlideshowOtherVideo(id: 1234, imageUrl: "https://assets.shwrm.net/images/e/g/eg57c52bac90415_500x643.jpg?1474358416", caption: PromoSlideshowOtherVideoCaption(title: "Testowy film 2", subtitle: "Testowy opis 2", color: .White)),
            PromoSlideshowOtherVideo(id: 12345, imageUrl: "https://assets.shwrm.net/images/q/r/qr576aa8fe20413_500x643.jpg?1466607870", caption: PromoSlideshowOtherVideoCaption(title: "Testowy film 3", subtitle: "Testowy opis 3", color: .Black)),
        ]
        let links = [
            PromoSlideshowLink(text: "My link 1", link: "https://www.showroom.pl/tag/ona"),
            PromoSlideshowLink(text: "My link 2", link: "https://www.showroom.pl/tag/on")
        ]
        let promoSlideshow = PromoSlideshow(brand: brand, video: video, otherVideos: otherVideos, links: links)
        
        return Observable.just(promoSlideshow)
            .doOnNext { [unowned self] result in
                self.promoSlideshow = result
        }
            .flatMap { [unowned self] (promoSlideshow: PromoSlideshow) -> Observable<PromoSlideshow> in
                let index = 0
                let pageData = self.createPageData(forPageAtIndex: index)!
                let prefetchObservable = self.prefetcher.prefetch(forPageIndex: index, withData: pageData)
                return prefetchObservable.flatMap { (value: AnyObject?) -> Observable<PromoSlideshow> in
                    return Observable.just(promoSlideshow)
                }
        }
    }
    
    func prefetchData(forPageAtIndex index: Int) {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return
        }
        prefetcher.prefetch(forPageIndex: index, withData: pageData)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    func data(forPageIndex index: Int) -> PromoSlideshowPageDataContainer? {
        guard let pageData = createPageData(forPageAtIndex: index) else {
            logError("Cannot create page data at index \(index)")
            return nil
        }
        let additionalData = prefetcher.additionalData(atPageIndex: index)
        return PromoSlideshowPageDataContainer(pageData: pageData, additionalData: additionalData)
    }
    
    private func createPageData(forPageAtIndex index: Int) -> PromoSlideshowPageData? {
        guard let slideshow = promoSlideshow else {
            return nil
        }
        
        if let step = slideshow.video.steps[safe: index] {
            return PromoSlideshowPageData(fromStep: step)
        } else {
            return .Summary(slideshow)
        }
    }
}

extension PromoSlideshowPageData {
    private init(fromStep step: PromoSlideshowVideoStep) {
        switch step.type {
        case .Image:
            self = .Image(link: step.link!, duration: step.duration)
        case .Video:
            self = .Video(step.link!)
        case .Product:
            self = .Product(product: step.product!, duration: step.duration)
        }
    }
}