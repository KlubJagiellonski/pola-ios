import Foundation
import UIKit

final class ProductStepViewController: ProductPageViewController, ProductPageViewControllerDelegate, ProductPagePreviewOverlayViewDelegate, PromoPageInterface {
    weak var pageDelegate: PromoPageDelegate?
    
    private weak var previewOverlay: ProductPagePreviewOverlayView?
    
    init(with resolver: DiResolver, productId: ObjectId) {
        super.init(resolver: resolver, productId: productId, product: nil, previewMode: true)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.previewOverlayView = createAndConfigureOverlayView()
        castView.previewMode = true
        
        model.state.productDetailsObservable.subscribeNext { [weak self] _ in
            self?.tryToInformAboutAllDataDownloaded(triggeredByImageDownloaded: false)
        }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pageDelegate?.promoPage(self, didChangeCurrentProgress: 0)
    }
    
    override func pageView(pageView: ProductPageView, didDownloadFirstImageWithSuccess success: Bool) {
        super.pageView(pageView, didDownloadFirstImageWithSuccess: success)
        tryToInformAboutAllDataDownloaded(triggeredByImageDownloaded: true)
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
    
    private func update(withProductDetailsVisible visible: Bool) {
        let animationDuration = 0.4
        
        castView.update(withPreviewModeEnabled: visible, animationDuration: animationDuration)
        previewOverlay?.update(withEnabled: visible, animationDuration: animationDuration)
        pageDelegate?.promoPage(self, willChangePromoPageViewState: visible ? .Close : .Paused, animationDuration: animationDuration)
    }
    
    private func tryToInformAboutAllDataDownloaded(triggeredByImageDownloaded triggeredByImageDownloaded: Bool) {
        var shouldInform = false
        if triggeredByImageDownloaded {
            shouldInform = model.state.productDetails != nil
        } else {
            shouldInform = castView.firstImageDownloaded && model.state.productDetails != nil
        }
        if shouldInform {
            pageDelegate?.promoPageDidDownloadAllData(self)
        }
    }
    
    // MARK:- PromoPageInterface
    
    func didTapPlay() {
        logInfo("Did tap play, previewOverlay \(previewOverlay)")
        update(withProductDetailsVisible: true)
    }
    
    func didTapDismiss() {
        logInfo("Did tap dismiss")
        dismissContentView()
    }
    
    // MARK:- ProductPagePreviewOverlayViewDelegate
    
    func previewOverlayDidTapOverlay(previewOverlay: ProductPagePreviewOverlayView) {
        logInfo("Did tap overlay")
        update(withProductDetailsVisible: false)
    }
    
    func previewOverlayDidTapInfoButton(previewOverlay: ProductPagePreviewOverlayView) {
        logInfo("Did tap info button")
        update(withProductDetailsVisible: false)
    }
    
    func previewOverlayDidTapWishlistButton(previewOverlay: ProductPagePreviewOverlayView) {
        let state = self.model.switchOnWishlist()
        logInfo("Did tap wishlist, switching to state \(state)")
        previewOverlay.update(withWishlistButtonSelected: state)
    }
    
    // MARK:- ProductPageViewControllerDelegate
    
    func productPage(page: ProductPageViewController, willChangeProductPageViewState newViewState: ProductPageViewState, animationDuration: Double?) {
        let promoViewState = PromoPageViewState(with: newViewState, overlayEnabled: previewOverlay?.enabled ?? true)
        pageDelegate?.promoPage(self, willChangePromoPageViewState: promoViewState, animationDuration: animationDuration)
    }
}

extension PromoPageViewState {
    init(with state: ProductPageViewState, overlayEnabled: Bool) {
        switch state {
        case .Default, .ContentHidden:
            self = overlayEnabled ? .Close : .Paused
        case .ContentExpanded:
            self = .Dismiss
        case .ImageGallery:
            self = .FullScreen
        }
    }
}