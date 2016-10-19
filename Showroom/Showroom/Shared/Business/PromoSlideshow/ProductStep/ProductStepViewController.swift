import Foundation
import UIKit

struct ProductStepDataEntry {
    let videoId: ObjectId
    let product: PromoSlideshowProduct
    let duration: Int
}

final class ProductStepViewController: ProductPageViewController, ProductPageViewControllerDelegate, ProductPagePreviewOverlayViewDelegate, PromoPageInterface {
    private let playAfterAddToBasketDelay = 1.0
    
    weak var pageDelegate: PromoPageDelegate?
    var focused: Bool = false {
        didSet {
            logInfo("focused did set: \(focused)")
            if focused && (previewOverlay?.enabled ?? false) {
                timer.play()
            } else if !focused {
                timer.pause()
            }
        }
    }
    var shouldShowProgressViewInPauseState: Bool { return false }
    
    private weak var previewOverlay: ProductPagePreviewOverlayView?
    private let timer: Timer
    private let videoId: ObjectId
    
    init(with resolver: DiResolver, dataEntry: ProductStepDataEntry) {
        self.timer = Timer(duration: dataEntry.duration, stepInterval: Constants.promoSlideshowTimerStepInterval)
        self.videoId = dataEntry.videoId
        super.init(resolver: resolver, productId: dataEntry.product.id, product: Product(product: dataEntry.product))
        
        delegate = self
        timer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.previewOverlayView = createAndConfigureOverlayView()
        castView.previewMode = true
    }
    
    override func pageView(pageView: ProductPageView, didDownloadFirstImageWithSuccess success: Bool) {
        super.pageView(pageView, didDownloadFirstImageWithSuccess: success)
        if success {
            pageDelegate?.promoPageDidDownloadAllData(self)
        }
    }
    
    override func logAddToBasketAnalytics(with productDetails: ProductDetails) {
        logAnalyticsEvent(AnalyticsEventId.ProductAddToCartClicked(model.productId, "video", productDetails.price))
    }
    
    private func createAndConfigureOverlayView() -> UIView {
        let bottomBarHeight = self.castView.descriptionViewInterface?.headerButtonSectionHeight ?? 0
        logInfo("Creating preview overlay view with bottom bar height \(bottomBarHeight)")
        let view = ProductPagePreviewOverlayView(bottomBarHeight: bottomBarHeight)
        view.update(withWishlistButtonSelected: self.model.isOnWishlist)
        view.delegate = self
        previewOverlay = view
        return view
    }
    
    private func update(withPreviewModeEnabled enabled: Bool) {
        let animationDuration = Constants.promoSlideshowStateChangedAnimationDuration
        
        castView.update(withPreviewModeEnabled: enabled, animationDuration: animationDuration)
        previewOverlay?.update(withEnabled: enabled, animationDuration: animationDuration)
        pageDelegate?.promoPage(self, willChangePromoPageViewState: enabled ? .Playing : .Paused(shouldShowProgressViewInPauseState), animationDuration: animationDuration)
        if enabled {
            timer.play()
        } else {
            timer.pause()
        }
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        logInfo("Did tap play, previewOverlay \(previewOverlay)")
        update(withPreviewModeEnabled: true)
    }
    
    func didTapDismiss() {
        logInfo("Did tap dismiss")
        dismissContentView()
    }
    
    // MARK:- ProductPagePreviewOverlayViewDelegate
    
    func previewOverlayDidTapOverlay(previewOverlay: ProductPagePreviewOverlayView) {
        logInfo("Did tap overlay")
        logAnalyticsEvent(AnalyticsEventId.VideoProductPhotoTapped(videoId))
        update(withPreviewModeEnabled: false)
    }
    
    func previewOverlayDidTapInfoButton(previewOverlay: ProductPagePreviewOverlayView) {
        logInfo("Did tap info button")
        logAnalyticsEvent(AnalyticsEventId.VideoProductInfoButtonTapped(videoId))
        update(withPreviewModeEnabled: false)
    }
    
    func previewOverlayDidTapWishlistButton(previewOverlay: ProductPagePreviewOverlayView) {
        let state = self.model.switchOnWishlist()
        logInfo("Did tap wishlist, switching to state \(state)")
        if state {
            logAnalyticsEvent(AnalyticsEventId.VideoProductAddedToWishlist(videoId))
        }
        previewOverlay.update(withWishlistButtonSelected: state)
    }
    
    // MARK:- ProductPageViewControllerDelegate
    
    func productPage(page: ProductPageViewController, willChangeProductPageViewState newViewState: ProductPageViewState, animationDuration: Double?) {
        let promoViewState = PromoPageViewState(with: newViewState, overlayEnabled: previewOverlay?.enabled ?? true, shouldShowStatusBarInPauseState: shouldShowProgressViewInPauseState)
        pageDelegate?.promoPage(self, willChangePromoPageViewState: promoViewState, animationDuration: animationDuration)
    }
}

extension ProductStepViewController: TimerDelegate {
    func timerDidEnd(timer: Timer) {
        pageDelegate?.promoPageDidFinished(self)
    }
    
    func timer(timer: Timer, didChangeProgress progress: Double) {
        pageDelegate?.promoPage(self, didChangeCurrentProgress: progress)
    }
}

extension ProductStepViewController: NavigationHandler {
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        if let simpleEvent = event as? SimpleNavigationEvent where simpleEvent.type == .ProductAddedToBasket {
            showAddToBasketSucccess()
            return true
        }
        return false
    }
}

extension PromoPageViewState {
    init(with state: ProductPageViewState, overlayEnabled: Bool, shouldShowStatusBarInPauseState: Bool) {
        switch state {
        case .Default, .ContentHidden:
            self = overlayEnabled ? .Playing : .Paused(shouldShowStatusBarInPauseState)
        case .ContentExpanded:
            self = .PausedWithDetailContent
        case .ImageGallery:
            self = .PausedWithFullscreenContent
        }
    }
}

extension Product {
    init(product: PromoSlideshowProduct) {
        self.id = product.id
        self.basePrice = product.basePrice
        self.brand = product.brand.name
        self.imageUrl = product.imageUrl
        self.name = product.name
        self.price = product.price
        self.lowResImageUrl = nil
    }
}