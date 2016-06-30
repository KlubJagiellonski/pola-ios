import Foundation
import UIKit
import Haneke

extension UIImageView {
    
    func loadImageFromUrl(url: String, width: CGFloat? = nil, height: CGFloat? = nil, failure fail: ((NSError?) -> ())? = nil, success succeed: ((UIImage) -> ())? = nil) {
        let url = NSURL.createImageUrl(url, width: width, height: height)
        hnk_setImageFromURL(url, format: UIImageView.defaultImageFormat, failure: fail, success: succeed)
    }
    
    func loadImageWithLowResImage(url: String, lowResUrl: String?, width: CGFloat? = nil, height: CGFloat? = nil, failure fail: ((NSError?) -> ())? = nil, success succeed: ((UIImage) -> ())? = nil) {
        let url = NSURL.createImageUrl(url, width: width, height: height)
        let fetcher = ImageWithLowResFetcher(url: url, lowResUrl: lowResUrl == nil ? nil : NSURL(string: lowResUrl!))
        
        let cache = Shared.imageCache
        let format = UIImageView.defaultImageFormat
        cache.addFormat(format)
        
        hnk_cancelSetImage()
        hnk_fetcher = fetcher
        var animated = false
        cache.fetch(fetcher: fetcher, formatName: format.name, failure: { [weak self] error in
            guard let strongSelf = self else { return }
            if strongSelf.hnk_shouldCancelForKey(fetcher.key) { return }
            
            strongSelf.hnk_fetcher = nil
            
            fail?(error)
            
        }) { [weak self] image in
            guard let strongSelf = self else { return }
            
            if strongSelf.hnk_shouldCancelForKey(fetcher.key) { return }
            
            // we don't want to stop fetcher when this is not final image
            if image.size.width == width {
                strongSelf.hnk_fetcher = nil
            }
            
            if let succeed = succeed {
                succeed(image)
            } else if animated {
                UIView.transitionWithView(strongSelf, duration: 0.1, options: .TransitionCrossDissolve, animations: {
                    strongSelf.image = image
                    }, completion: nil)
            } else {
                strongSelf.image = image
            }
        }
        animated = true
    }
    
    static var defaultImageFormat: Format<UIImage> {
        return Format<UIImage>(name: "original")
    }
}

class ImageWithLowResFetcher: Fetcher<UIImage> {
    let lowResUrl: NSURL?
    let url: NSURL
    var cancelled = false
    var onFinished: (() -> ())?
    var cache: Cache<UIImage> {
        let cache = Shared.imageCache
        cache.addFormat(UIImageView.defaultImageFormat)
        return cache
    }
    
    init(url: NSURL, lowResUrl: NSURL?) {
        self.lowResUrl = lowResUrl
        self.url = url
        super.init(key: url.absoluteString)
    }
    
    // it happens when there is no cached data for url
    override func fetch(failure fail: ((NSError?) -> ()), success succeed: (UIImage) -> ()) {
        let cache = Shared.imageCache
        cache.addFormat(UIImageView.defaultImageFormat)
        if let lowRes = lowResUrl {
            fetchLowResImage(lowRes, failure: fail, success: succeed)
        } else {
            fetchImage(failure: fail, success: succeed)
        }
    }
    
    override func cancelFetch() {
        self.cancelled = true
    }
    
    private func fetchLowResImage(lowRes: NSURL, failure fail: ((NSError?) -> ()), success succeed: (UIImage) -> ()) {
        cache.fetch(key: lowRes.absoluteString, failure: { [weak self] error in
            if self?.cancelled ?? false { return }
            self?.fetchImage(failure: fail, success: succeed)
        }) { [weak self] image in
            if self?.cancelled ?? false { return }
            self?.success(image, success: succeed)
            self?.fetchImage(failure: fail, success: succeed)
        }
    }
    
    private func fetchImage(failure fail: ((NSError?) -> ()), success succeed: (UIImage) -> ()) {
        cache.fetch(URL: url, failure: { [weak self] error in
            if self?.cancelled ?? false { return }
            self?.failure(error, failure: fail)
        }) { [weak self] image in
            if self?.cancelled ?? false { return }
            self?.success(image, success: succeed)
        }
    }
    
    private func success(image: UIImage, success succeed: (UIImage) -> ()) {
        dispatch_async(dispatch_get_main_queue()) { succeed(image) }
    }
    
    private func failure(error: NSError?, failure fail: NSError? -> ()) {
        dispatch_async(dispatch_get_main_queue()) { fail(error) }
    }
}