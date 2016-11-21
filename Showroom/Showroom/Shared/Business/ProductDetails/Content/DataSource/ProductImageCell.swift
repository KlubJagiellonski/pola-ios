import Foundation
import UIKit
import SnapKit

protocol ProductImageCellDelegate: class {
    func productImageCell(cell: ProductImageCell, didDownloadImageWithSuccess success: Bool)
}

final class ProductImageCell: UICollectionViewCell, ProductImageCellInterface, UIScrollViewDelegate {
    private let minImageZoom: CGFloat = 1.0
    private let maxImageZoom: CGFloat = 3.0
    private let doubleTapZoom: CGFloat = 2.0
    
    private let contentViewSwitcher: ViewSwitcher
    private let contentScrollView = UIScrollView()
    private let imageView = UIImageView()
    
    private weak var doubleTapGestureRecognizer: UITapGestureRecognizer?
    private var topOffset: CGFloat = 0
    var fullScreenMode: Bool = false {
        didSet {
            updateLoadingTopContentOffset()
            
            guard fullScreenMode != oldValue else { return }
            
            let imageHeight = ceil(bounds.width / CGFloat(Dimensions.defaultImageRatio))
            
            doubleTapGestureRecognizer?.enabled = fullScreenMode
            contentScrollView.scrollEnabled = fullScreenMode
            contentScrollView.maximumZoomScale = fullScreenMode ? maxImageZoom : minImageZoom
            contentScrollView.zoomScale = 1.0
            
            topOffset = fullScreenMode ? bounds.height * 0.5 - imageHeight * 0.5: 0
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var imageVisible: Bool {
        set { imageView.alpha = newValue ? 1 : 0 }
        get { return imageView.alpha == 1 }
    }
    var image: UIImage? { return imageView.image }
    var screenInset: UIEdgeInsets?
    weak var delegate: ProductImageCellDelegate?
    
    override init(frame: CGRect) {
        contentViewSwitcher = ViewSwitcher(successView: contentScrollView, initialState: .Success)
        
        super.init(frame: frame)
        
        updateLoadingTopContentOffset()
        
        imageView.contentMode = .ScaleAspectFit
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductImageCell.didDoubleTapView))
        doubleTapGestureRecognizer.enabled = fullScreenMode
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        contentScrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        contentScrollView.contentSize = bounds.size
        contentScrollView.delegate = self
        contentScrollView.minimumZoomScale = minImageZoom
        contentScrollView.maximumZoomScale = fullScreenMode ? maxImageZoom : minImageZoom
        contentScrollView.scrollEnabled = fullScreenMode
        
        contentScrollView.addSubview(imageView)
        contentView.addSubview(contentViewSwitcher)
        
        self.doubleTapGestureRecognizer = doubleTapGestureRecognizer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didDoubleTapView(tapGestureRecognizer: UITapGestureRecognizer) {
        let zoom = contentScrollView.zoomScale == 1.0 ? doubleTapZoom : 1.0
        let zoomRect = zoomRectForScale(zoom, withCenter: tapGestureRecognizer.locationInView(tapGestureRecognizer.view))
        contentScrollView.zoomToRect(zoomRect, animated: true)
    }
    
    func update(withImageUrl imageUrl: String, lowResImageUrl: String?) {
        imageView.image = nil
        
        let onRetrieveFromCache: (UIImage?) -> () = { [weak self]image in
            self?.contentViewSwitcher.changeSwitcherState(image == nil ? .Loading : .Success, animated: false)
        }
        
        let onFailure: (NSError?) -> () = { [weak self] error in
            guard let `self` = self else { return }
            logInfo("Failed to download image \(error)")
            self.delegate?.productImageCell(self, didDownloadImageWithSuccess: false)
        }
        
        let onSuccess: (UIImage) -> () = { [weak self] image in
            guard let `self` = self else { return }
            self.delegate?.productImageCell(self, didDownloadImageWithSuccess: true)
            self.contentViewSwitcher.changeSwitcherState(.Success)
        }
        
        imageView.loadImageWithLowResImage(imageUrl, lowResUrl: lowResImageUrl, width: bounds.width, onRetrievedFromCache: onRetrieveFromCache, failure: onFailure, success: onSuccess)
    }
    
    func didEndDisplaying() {}
    
    func willBeDisplaying() {
        contentViewSwitcher.loadingView.startAnimation()
    }
    
    // doing it on frame because there were 1000 of problems with autolayout here
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        contentViewSwitcher.frame = self.bounds
        imageView.frame = CGRectMake(0, topOffset, bounds.width, ceil(bounds.width / CGFloat(Dimensions.defaultImageRatio)))
    }
    
    // MARK:- UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var frame = imageView.frame;
        if frame.size.width < scrollView.bounds.size.width
        {
            frame.origin.x = (scrollView.bounds.size.width - frame.size.width) / 2.0;
        } else {
            frame.origin.x = 0.0;
        }
        if frame.size.height < scrollView.bounds.size.height {
            frame.origin.y = (scrollView.bounds.size.height - frame.size.height) / 2.0;
        } else {
            frame.origin.y = 0.0;
        }
        imageView.frame = frame;
    }
    
    // MARK:- Utilities
    private func zoomRectForScale(scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRectZero
        
        zoomRect.size.height = contentScrollView.frame.size.height / scale;
        zoomRect.size.width = contentScrollView.frame.size.width / scale;
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
        
        return zoomRect;
    }
    
    private func updateLoadingTopContentOffset() {
        let screenBottomInset = screenInset?.bottom ?? 0
        let loadingContentInset = fullScreenMode ? 0 : -screenBottomInset / 2
        contentViewSwitcher.loadingView.indicatorCenterYOffset = loadingContentInset
    }
}
