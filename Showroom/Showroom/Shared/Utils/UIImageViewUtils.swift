import Foundation
import UIKit
import Kingfisher

private var imageDownloadingInProgressKey: Void?

extension UIImageView {
    
    static func scaledImageSize(size: CGFloat?, scale: CGFloat = UIScreen.mainScreen().scale) -> Int? {
        guard let size = size else {
            return nil
        }
        return Int(size * scale)
    }
    
    static func scaledImageSize(size: CGFloat, scale: CGFloat = UIScreen.mainScreen().scale) -> Int {
        return Int(size * scale)
    }
    
    private(set) var imageDownloadingInProgress: Bool {
        get {
            return objc_getAssociatedObject(self, &imageDownloadingInProgressKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &imageDownloadingInProgressKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func loadImageFromUrl(url: String, width: CGFloat? = nil, height: CGFloat? = nil, onRetrievedFromCache: (UIImage? -> Void)? = nil, failure fail: ((NSError?) -> ())? = nil, success succeed: ((UIImage) -> ())? = nil) {
        let url = NSURL.createImageUrl(url, width: UIImageView.scaledImageSize(width), height: UIImageView.scaledImageSize(height))
        
        imageDownloadingInProgress = true
        
        let completionHandler: CompletionHandler = { [weak self] (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) in
            if let image = image {
                succeed?(image)
            } else {
                fail?(error)
            }
            self?.imageDownloadingInProgress = false
        }
        
        if let onRetrievedFromCache = onRetrievedFromCache {
            let cacheCompletionHandler: CompletionHandler = { [weak self] (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) in
                guard let `self` = self else { return }
                
                onRetrievedFromCache(image)
                if let image = image {
                    succeed?(image)
                    self.imageDownloadingInProgress = false
                } else {
                    self.kf_setImageWithURL(
                        url,
                        placeholderImage: self.image,
                        optionsInfo: succeed == nil ? [.Transition(ImageTransition.Fade(0.2)), .ForceRefresh] : [],
                        completionHandler: completionHandler
                    )
                }
            }
            
            kf_setImageWithURL(
                url,
                placeholderImage: image,
                optionsInfo: [.OnlyFromCache],
                completionHandler: cacheCompletionHandler
            )
        } else {
            kf_setImageWithURL(
                url,
                placeholderImage: image,
                optionsInfo: succeed == nil ? [.Transition(ImageTransition.Fade(0.2))] : [],
                completionHandler: completionHandler
            )
        }
    }
    
    func loadImageWithLowResImage(url: String, lowResUrl: String?, width: CGFloat? = nil, height: CGFloat? = nil, onRetrievedFromCache: (UIImage? -> Void)? = nil, failure fail: ((NSError?) -> ())? = nil, success succeed: ((UIImage) -> ())? = nil) {
        guard let lowResLink = lowResUrl, let lowResUrl = NSURL(string: lowResLink) else {
            loadImageFromUrl(url, width: width, height: height, onRetrievedFromCache:  onRetrievedFromCache, failure: fail, success: succeed)
            return
        }

        logInfo("Retrieving image with low res \(url), lowRes \(lowResUrl)")
        
        let url = NSURL.createImageUrl(url, width: UIImageView.scaledImageSize(width), height: UIImageView.scaledImageSize(height))
        
        let completionHandler: CompletionHandler = { [weak self] (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) in
            logInfo("Retrieved high res")
            if let image = image {
                succeed?(image)
            } else {
                fail?(error)
            }
            self?.imageDownloadingInProgress = false
        }
        
        let lowResFromCacheCompletionHandler: CompletionHandler = { [weak self]
            (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) in
            guard let `self` = self else { return }
            
            logInfo("Retrieved high res from cache \(image != nil)")
            
            onRetrievedFromCache?(image)
            
            //third, when check for low res cached image ends, then download high res
            self.kf_setImageWithURL(
                url,
                placeholderImage: image,
                optionsInfo: succeed == nil ? [.Transition(ImageTransition.Fade(0.2))] : [],
                completionHandler: completionHandler
            )
        }
        
        let highResFromCacheCompletionHandler: CompletionHandler = { [weak self]
            (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) in
            guard let `self` = self else { return }
            
            logInfo("Retrieve high res from cache \(image != nil)")
            
            if let image = image {
                onRetrievedFromCache?(image)
                succeed?(image)
                
                self.imageDownloadingInProgress = false
            } else {
                //second, if high res does not exist check if low res is in cache
                self.kf_setImageWithURL(
                    lowResUrl,
                    placeholderImage: self.image,
                    optionsInfo: [.OnlyFromCache],
                    completionHandler: lowResFromCacheCompletionHandler
                )
            }
        }
        
        imageDownloadingInProgress = true
        
        //first, check if high res is in cache
        kf_setImageWithURL(
            url,
            placeholderImage: self.image,
            optionsInfo: [.OnlyFromCache],
            completionHandler: highResFromCacheCompletionHandler
        )
    }
}