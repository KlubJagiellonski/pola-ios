import Foundation
import UIKit
import SnapKit

protocol ProductDescriptionViewInterface: class {
    var headerHeight: CGFloat { get }
    var headerButtonSectionHeight: CGFloat { get }
    var touchRequiredView: UIView { get } // view for which we want to disable uitapgesturerecognizer
    var previewMode: Bool { get set }
    var expandedProgress: CGFloat { get set }
    weak var delegate: ProductDescriptionViewDelegate? { get set }
    
    func showAddToBasketSucccess()
}

protocol ProductPageViewDelegate: ViewSwitcherDelegate, ProductDescriptionViewDelegate {
    func pageView(pageView: ProductPageView, willChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?)
    func pageView(pageView: ProductPageView, didChangePageViewState newPageViewState: ProductPageViewState, animationDuration: Double?)
    func pageViewDidTapShareButton(pageView: ProductPageView)
    func pageViewDidTapWishlistButton(pageView: ProductPageView)
    func pageViewDidSwitchedImage(pageView: ProductPageView)
    func pageView(pageView: ProductPageView, didDownloadFirstImageWithSuccess success: Bool)
    func pageViewDidLoadVideo(pageView: ProductPageView, atIndex index: Int, asset: AVAsset)
    func pageViewDidFinishVideo(pageView: ProductPageView, atIndex index: Int)
    func pageViewDidFailedToLoadVideo(pageView: ProductPageView, atIndex index: Int)
}

enum ProductPageViewState {
    case Default
    case ContentExpanded
    case ImageGallery
    case ContentHidden
}

class ProductPageView: ViewSwitcher, UICollectionViewDelegateFlowLayout {
    private let defaultDescriptionTopMargin: CGFloat = 70
    private let descriptionDragVelocityThreshold: CGFloat = 200
    private static let defaultContentAnimationDuration = 0.4
    private let verticalButtonsContentMargin: CGFloat = 8
    
    private let containerView = UIView()
    private let imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = VerticalPageControl()
    private let contentContainerView = UIView()
    private let buttonStackView = UIStackView()
    private let wishlistButton = UIButton()
    private let shareButton = UIButton()
    
    private let imageDataSource: ProductImageDataSource
    
    private var contentInset: UIEdgeInsets?
    private var contentTopConstraint: Constraint?
    private var currentTopContentOffset: CGFloat = 0 {
        didSet {
            descriptionViewInterface?.expandedProgress = calculateDescriptionExpandedProgress()
        }
    }
    private(set) var viewState: ProductPageViewState = .Default {
        didSet {
            imageCollectionView.scrollEnabled = viewState != .ContentExpanded
            contentTopConstraint?.updateOffset(currentTopContentOffset)
            imageDataSource.state = viewState == .ImageGallery ? .FullScreen : .Default
            configurePageControlAlpha()
        }
    }
    var previewOverlayView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let previewOverlayView = previewOverlayView else { return }
            
            containerView.addSubview(previewOverlayView)
            previewOverlayView.snp_makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    var previewMode: Bool = false {
        didSet {
            wishlistButton.alpha = previewMode ? 0 : 1
            shareButton.alpha = previewMode ? 0 : 1
            configurePageControlAlpha()
            descriptionViewInterface?.previewMode = previewMode
        }
    }
    weak var descriptionViewInterface: ProductDescriptionViewInterface? {
        didSet {
            currentTopContentOffset = calculateTopContentOffset(forViewState: .Default)
            contentTopConstraint?.updateOffset(currentTopContentOffset)
            imageDataSource.screenInset = UIEdgeInsets(top: 0, left: 0, bottom: -calculateTopContentOffset(forViewState: .Default), right: 0)
            imageDataSource.fullScreenInset = UIEdgeInsets(top: 0, left: 0, bottom: -calculateTopContentOffset(forViewState: .ImageGallery), right: 0)
        }
    }
    
    var currentImageIndex: Int {
        let pageHeight = imageCollectionView.frame.height
        return Int(imageCollectionView.contentOffset.y / pageHeight)
    }
    var contentGestureRecognizerEnabled = true {
        didSet {
            contentContainerView.gestureRecognizers?.forEach { $0.enabled = contentGestureRecognizerEnabled }
        }
    }
    weak var delegate: ProductPageViewDelegate? {
        didSet {
            switcherDelegate = delegate
            descriptionViewInterface?.delegate = delegate
        }
    }
    
    init(contentView: UIView, contentInset: UIEdgeInsets?, videoAssetsFactory: Int -> AVAsset) {
        imageDataSource = ProductImageDataSource(collectionView: imageCollectionView, assetsFactory: videoAssetsFactory)
        
        super.init(successView: containerView)
        
        self.contentInset = contentInset
        
        switcherDataSource = self
        
        let imageCollectionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductPageView.didTapOnImageCollectionView))
        imageCollectionTapGestureRecognizer.delegate = self
        
        let contentContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductPageView.didTapOnDescriptionView))
        contentContainerTapGestureRecognizer.delegate = self
        
        imageDataSource.productPageView = self
        imageCollectionView.backgroundColor = UIColor.clearColor()
        imageCollectionView.dataSource = imageDataSource
        imageCollectionView.delegate = self
        imageCollectionView.configureForPaging(withDirection: .Vertical)
        imageCollectionView.addGestureRecognizer(imageCollectionTapGestureRecognizer)
        if #available(iOS 10.0, *) {
            imageCollectionView.prefetchingEnabled = false
        }
        
        pageControl.currentPage = 0
        
        contentContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ProductPageView.didPanOnDescriptionView)))
        contentContainerView.addGestureRecognizer(contentContainerTapGestureRecognizer)
        contentContainerView.layer.masksToBounds = true
        
        buttonStackView.axis = .Horizontal
        buttonStackView.spacing = 10
        
        wishlistButton.setImage(UIImage(asset: .Ic_do_ulubionych), forState: .Normal)
        wishlistButton.setImage(UIImage(asset: .Ic_w_ulubionych), forState: .Selected)
        wishlistButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0)
        wishlistButton.addTarget(self, action: #selector(ProductPageView.didTapWishlistButton(_:)), forControlEvents: .TouchUpInside)
        wishlistButton.applyCircleStyle()
        
        shareButton.setImage(UIImage(asset: .Ic_share), forState: .Normal)
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 1, 1, 0)
        shareButton.addTarget(self, action: #selector(ProductPageView.didTapShareButton(_:)), forControlEvents: .TouchUpInside)
        shareButton.applyCircleStyle()
        
        buttonStackView.addArrangedSubview(wishlistButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        contentContainerView.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)))
        contentContainerView.addSubview(contentView)
        
        containerView.addSubview(imageCollectionView)
        containerView.addSubview(pageControl)
        containerView.addSubview(contentContainerView)
        containerView.addSubview(buttonStackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with product: Product?) {
        guard let p = product else { return }
        imageDataSource.lowResImageUrl = p.lowResImageUrl
        imageDataSource.update(withImageUrls: [p.imageUrl], videos: [])
    }
    
    func update(with productDetails: ProductDetails?) {
        guard let p = productDetails else { return }
        
        imageDataSource.update(withImageUrls: p.images.map { $0.url }, videos: p.videos)
        pageControl.numberOfPages = imageDataSource.pageCount
        pageControl.invalidateIntrinsicContentSize()
    }
    
    func update(withWishlistButtonSelected selected: Bool) {
        wishlistButton.selected = selected
    }
    
    func update(withPreviewModeEnabled previewModeEnabled: Bool, animationDuration: Double?) {
        UIView.animateWithDuration(animationDuration ?? 0) { [unowned self] in
            self.previewMode = previewModeEnabled
        }
    }
    
    func changeViewState(viewState: ProductPageViewState, animationDuration: Double? = defaultContentAnimationDuration, forceUpdate: Bool = false, completion: (() -> Void)? = nil) {
        if self.viewState == viewState && !forceUpdate { return }
        
        delegate?.pageView(self, willChangePageViewState: viewState, animationDuration: animationDuration)
        
        layoutIfNeeded()
        setNeedsLayout()
        UIView.animateWithDuration(animationDuration ?? 0, delay: 0, options: [.CurveEaseInOut], animations: {
            self.currentTopContentOffset = self.calculateTopContentOffset(forViewState: viewState)
            self.viewState = viewState
            self.layoutIfNeeded()
        }) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.pageView(strongSelf, didChangePageViewState: strongSelf.viewState, animationDuration: animationDuration)
            completion?()
        }
    }
    
    func scrollToImage(atIndex index: Int) {
        imageDataSource.scrollToImage(atIndex: index)
    }
    
    func didDownloadFirstImage(withSuccess success: Bool) {
        delegate?.pageView(self, didDownloadFirstImageWithSuccess: success)
    }
    
    func didLoadVideo(atIndex index: Int, asset: AVAsset) {
        delegate?.pageViewDidLoadVideo(self, atIndex: index, asset: asset)
    }
    
    func didFinishVideo(atIndex index: Int) {
        delegate?.pageViewDidFinishVideo(self, atIndex: index)
    }
    
    func didFailedToLoadVideo(atIndex index: Int) {
        delegate?.pageViewDidFailedToLoadVideo(self, atIndex: index)
    }

    func showAddToBasketSucccess() {
        descriptionViewInterface?.showAddToBasketSucccess()
    }
    
    private func configureCustomConstraints() {
        imageCollectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentContainerView.snp_makeConstraints { make in
            contentTopConstraint = make.top.equalTo(contentContainerView.superview!.snp_bottom).constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().offset(-defaultDescriptionTopMargin)
        }
        
        contentContainerView.subviews.forEach { view in
            view.snp_makeConstraints { make in make.edges.equalToSuperview() }
        }
        
        pageControl.snp_makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.leading.equalTo(10)
        }
        
        buttonStackView.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalTo(contentContainerView.snp_top).offset(-verticalButtonsContentMargin)
        }
        
        shareButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(shareButton.snp_width)
        }
        
        wishlistButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(wishlistButton.snp_width)
        }
    }
    
    private func calculateTopContentOffset(forViewState viewState: ProductPageViewState) -> CGFloat {
        switch viewState {
        case .Default:
            return -((descriptionViewInterface?.headerHeight ?? 0) + (contentInset?.bottom ?? 0))
        case .ContentExpanded:
            return defaultDescriptionTopMargin - bounds.height
        case .ImageGallery, .ContentHidden:
            return verticalButtonsContentMargin + Dimensions.circleButtonDiameter
        }
    }
    
    private func calculateDescriptionExpandedProgress() -> CGFloat {
        let defaultOffset = calculateTopContentOffset(forViewState: .Default)
        let expandedOffset = calculateTopContentOffset(forViewState: .ContentExpanded)
        return abs((currentTopContentOffset - defaultOffset) / (expandedOffset - defaultOffset))
    }
    
    private func didChangeImage() {
        pageControl.currentPage = currentImageIndex
        delegate?.pageViewDidSwitchedImage(self)
    }
    
    private func configurePageControlAlpha() {
        pageControl.alpha = (viewState == .ImageGallery || previewMode) ? 0 : 1
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        imageDataSource.didEndDisplayingCell(cell, forItemAtIndexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        didChangeImage()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        didChangeImage()
    }
}

extension ProductPageView {
    func didPanOnDescriptionView(panGestureRecognizer: UIPanGestureRecognizer) {
        let bottomOffset = (descriptionViewInterface?.headerHeight ?? 0) + (contentInset?.bottom ?? 0)
        let movableY = bounds.height - defaultDescriptionTopMargin - bottomOffset
        var moveY = panGestureRecognizer.translationInView(contentContainerView).y
        
        let contentVisible = viewState == .ContentExpanded
        
        switch panGestureRecognizer.state {
        case .Changed:
            if contentVisible && moveY < 0 { moveY = 0 }
            else if contentVisible && moveY > movableY { moveY = movableY }
            else if !contentVisible && moveY > 0 { moveY = 0 }
            else if !contentVisible && moveY < -movableY { moveY = -movableY }
            
            let newOffset = contentVisible ? (defaultDescriptionTopMargin - bounds.height) + moveY: -bottomOffset + moveY
            self.currentTopContentOffset = newOffset
            self.contentTopConstraint?.updateOffset(newOffset)
        case .Ended:
            let movedMoreThanHalf = contentVisible && moveY > movableY * 0.5 || !contentVisible && moveY < -movableY * 0.5
            
            let yVelocity = panGestureRecognizer.velocityInView(contentContainerView).y
            let movedFasterForward = contentVisible && yVelocity > descriptionDragVelocityThreshold || !contentVisible && yVelocity < -descriptionDragVelocityThreshold
            let movedFasterBackward = contentVisible && yVelocity < -descriptionDragVelocityThreshold || !contentVisible && yVelocity > descriptionDragVelocityThreshold
            
            var newViewState = viewState
            if movedFasterForward || (movedMoreThanHalf && !movedFasterBackward) {
                newViewState = contentVisible ? .Default : .ContentExpanded
            }
            
            changeViewState(newViewState, animationDuration: 0.2, forceUpdate: true)
        default: break
        }
    }
    
    func didTapOnDescriptionView(tapGestureRecognizer: UITapGestureRecognizer) {
        let contentVisible = viewState == .ContentExpanded
        let newViewState: ProductPageViewState = contentVisible ? .Default : .ContentExpanded
        changeViewState(newViewState)
    }
    
    func didTapOnImageCollectionView(tapGestureRecognizer: UITapGestureRecognizer) {
        switch viewState {
        case .Default:
            changeViewState(.ImageGallery)
        case .ContentExpanded, .ImageGallery, .ContentHidden:
            changeViewState(.Default)
        }
    }
    
    @objc private func didTapWishlistButton(sender: UIButton) {
        delegate?.pageViewDidTapWishlistButton(self)
    }
    
    @objc private func didTapShareButton(sender: UIButton) {
        delegate?.pageViewDidTapShareButton(self)
    }
}

extension ProductPageView: ImageAnimationTargetViewInterface {
    var viewsAboveImageVisibility: Bool {
        set {
            guard newValue != viewsAboveImageVisibility else {
                return
            }
            pageControl.alpha = newValue ? 1 : 0
            
            currentTopContentOffset = calculateTopContentOffset(forViewState: newValue ? .Default : .ImageGallery)
            contentTopConstraint?.updateOffset(currentTopContentOffset)
            layoutIfNeeded()
        }
        get {
            return pageControl.alpha == 1
        }
    }
    
    var highResImage: UIImage? {
        // we don't want to animated different animation from that on product list
        guard currentImageIndex == 0 else { return nil }
        return imageDataSource.highResImage(forIndex: currentImageIndex)
    }
    
    var highResImageVisible: Bool {
        set { imageDataSource.highResImageVisible = newValue }
        get { return imageDataSource.highResImageVisible }
    }
}

extension ProductPageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer.view == contentContainerView {
            if let touchHandlingDelegate = touch.view as? TouchHandlingDelegate {
                return !touchHandlingDelegate.shouldConsumeTouch(touch)
            }
            if let touchRequiredView = descriptionViewInterface?.touchRequiredView, let touchView = touch.view {
                return !touchView.isDescendantOfView(touchRequiredView)
            }
        }
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGestureRecognizer = otherGestureRecognizer as? UITapGestureRecognizer where gestureRecognizer.view == imageCollectionView {
            return tapGestureRecognizer.numberOfTapsRequired == 2 && viewState == .ImageGallery
        }
        return false
    }
}

extension ProductPageView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}
