import Foundation
import RxSwift

typealias DataLink = String

enum PromoSlideshowPageData {
    case Image(DataLink)
    case Video(DataLink)
    case Product(ObjectId)
    case Summary(PromoSlideshow)
}

final class PromoSlideshowModel {
    private let slideshowId: Int
    private var promoSlideshow: PromoSlideshow?
    
    init(slideshowId: Int) {
        self.slideshowId = slideshowId
    }
    
    func fetchPromoSlideshow() -> Observable<PromoSlideshow> {
        //TODO: real api
        let brand = Brand(id: 1234, name: "Test brand")
        //TODO: add correct test links
        let steps = [
            PromoSlideshowVideoStep(type: .Image, link: "", duration: 2000),
            PromoSlideshowVideoStep(type: .Video, link: "", duration: 5000),
            PromoSlideshowVideoStep(type: .Product, link: "", duration: 3000),
        ]
        let video = PromoSlideshowVideo(steps: steps, duration: steps.reduce(0, combine: { $0 + $1.duration }))
        
        let otherVideos = [
            PromoSlideshowOtherVideo(imageUrl: "", link: ""),
            PromoSlideshowOtherVideo(imageUrl: "", link: "")
        ]
        let links = [
            PromoSlideshowLink(text: "My link 1", link: ""),
            PromoSlideshowLink(text: "My link 2", link: "")
        ]
        let promoSlideshow = PromoSlideshow(brand: brand, video: video, otherVideos: otherVideos, links: links)
        return Observable.just(promoSlideshow).doOnNext { [weak self] result in
            self?.promoSlideshow = result
        }
    }
    
    func prefetchData(forPageAtIndex index: Int) {
        //TODO: prefetch
    }
    
    func data(forPageIndex index: Int) -> PromoSlideshowPageData? {
        guard let slideshow = promoSlideshow else {
            logError("No slideshow while retrieving data \(promoSlideshow)")
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
            self = .Image(step.link)
        case .Video:
            self = .Image(step.link)
        case .Product:
            self = .Product(78854) //todo handle product link
        }
    }
}