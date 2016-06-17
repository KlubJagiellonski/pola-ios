import Foundation
import UIKit
import SnapKit
import RxSwift

protocol ProductDescriptionViewInterface: class {
    var headerHeight: CGFloat { get }
    var calculatedHeaderHeight: CGFloat { get }
    var touchRequiredView: UIView { get } // view for which we want to disable uitapgesturerecognizer
}

protocol ProductPageViewDelegate: class {
    func pageView(pageView: ProductPageView, didChangePageViewState pageViewState: ProductPageViewState)
    func pageViewDidTapShareButton(pageView: ProductPageView)
}

enum ProductPageViewState {
    case Default
    case ContentVisible
    case ImageGallery
}

class ProductPageView: UIView, UICollectionViewDelegateFlowLayout {
    private let defaultDescriptionTopMargin: CGFloat = 70
    private let descriptionDragVelocityThreshold: CGFloat = 200
    private let defaultContentAnimationDuration = 0.4
    
    private let imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = VerticalPageControl()
    private let contentContainerView = UIView()
    private let buttonStackView = UIStackView()
    private let whishlistButton = UIButton()
    private let shareButton = UIButton()
    
    private let modelState: ProductPageModelState
    private let imageDataSource: ProductImageDataSource
    private let disposeBag = DisposeBag()
    
    private var contentTopConstraint: Constraint?
    private(set) var viewState: ProductPageViewState = .Default {
        didSet {
            guard oldValue != viewState else { return }
            delegate?.pageView(self, didChangePageViewState: viewState)
            imageCollectionView.scrollEnabled = viewState != ProductPageViewState.ContentVisible
        }
    }
    private weak var descriptionViewInterface: ProductDescriptionViewInterface?
    
    var currentImageIndex: Int {
        let pageHeight = imageCollectionView.frame.height
        return Int(imageCollectionView.contentOffset.y / pageHeight)
    }
    var contentInset: UIEdgeInsets?
    var contentGestureRecognizerEnabled = true {
        didSet {
            contentContainerView.gestureRecognizers?.forEach { $0.enabled = contentGestureRecognizerEnabled }
        }
    }
    weak var delegate: ProductPageViewDelegate?
    
    init(contentView: UIView, descriptionViewInterface: ProductDescriptionViewInterface, modelState: ProductPageModelState) {
        self.descriptionViewInterface = descriptionViewInterface
        self.modelState = modelState
        imageDataSource = ProductImageDataSource(collectionView: imageCollectionView)
        
        super.init(frame: CGRectZero)
        
        modelState.productDetailsObservable.subscribeNext(updateProductDetails).addDisposableTo(disposeBag)
        configure(forProduct: modelState.product)
        
        imageCollectionView.backgroundColor = UIColor.clearColor()
        imageCollectionView.dataSource = imageDataSource
        imageCollectionView.delegate = self
        imageCollectionView.pagingEnabled = true
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductPageView.didTapOnImageCollectionView)))
        let flowLayout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        pageControl.currentPage = 0
        
        contentContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ProductPageView.didPanOnDescriptionView)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductPageView.didTapOnDescriptionView))
        tapGestureRecognizer.delegate = self
        contentContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        buttonStackView.axis = .Horizontal
        buttonStackView.spacing = 10
        
        whishlistButton.setImage(UIImage(asset: .Ic_do_ulubionych), forState: .Normal)
        whishlistButton.setImage(UIImage(asset: .Ic_w_ulubionych), forState: .Selected)
        whishlistButton.applyCircleStyle()
        
        shareButton.setImage(UIImage(asset: .Ic_share), forState: .Normal)
        shareButton.addTarget(self, action: #selector(ProductPageView.didTapShareButton(_:)), forControlEvents: .TouchUpInside)
        shareButton.applyCircleStyle()
        
        buttonStackView.addArrangedSubview(whishlistButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        contentContainerView.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)))
        contentContainerView.addSubview(contentView)
        
        addSubview(imageCollectionView)
        addSubview(pageControl)
        addSubview(contentContainerView)
        addSubview(buttonStackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(forProduct product: Product?) {
        guard let p = product else { return } //todo it should show full screen spinner when there is no product info
        imageDataSource.lowResImageUrl = p.lowResImageUrl
        imageDataSource.imageUrls = [p.imageUrl]
    }
    
    private func updateProductDetails(productDetails: ProductDetails?) {
        guard let p = productDetails else { return }
        
        imageDataSource.imageUrls = p.images.map { $0.url }
        pageControl.numberOfPages = imageDataSource.imageUrls.count
        pageControl.invalidateIntrinsicContentSize()
        
        updateContentPosition(withAnimation: true)
    }
    
    var currentTopContentOffset:CGFloat = 0
    private func updateContentPosition(withAnimation animation: Bool, animationDuration: Double = 0.3, forceOffsetUpdate: Bool = false, completion: (() -> Void)? = nil) {
        let topContentOffset = calculateTopContentOffset()
        if topContentOffset == currentTopContentOffset && !forceOffsetUpdate {
            return
        }
        currentTopContentOffset = topContentOffset
        
        self.layoutIfNeeded()
        
        self.setNeedsLayout()
        UIView.animateWithDuration(animation ? animationDuration : 0) { [unowned self] in
            self.contentTopConstraint?.updateOffset(topContentOffset)
            self.layoutIfNeeded()
        }
    }
    
    func changeViewState(viewState: ProductPageViewState, animated: Bool, completion: (() -> Void)? = nil) {
        self.viewState = viewState
        
        updateContentPosition(withAnimation: animated, animationDuration: defaultContentAnimationDuration, completion: completion)
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
            make.bottom.equalTo(contentContainerView.snp_top).offset(-8)
        }
        
        shareButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(shareButton.snp_width)
        }
        
        whishlistButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(whishlistButton.snp_width)
        }
    }
    
    private func calculateTopContentOffset() -> CGFloat {
        //TODO add ImageGallery state handling
        let notVisibleOffset = (descriptionViewInterface?.calculatedHeaderHeight ?? 0) + (contentInset?.bottom ?? 0)
        return viewState == .ContentVisible ? defaultDescriptionTopMargin - bounds.height: -notVisibleOffset
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = currentImageIndex
    }
}

extension ProductPageView {
    func didPanOnDescriptionView(panGestureRecognizer: UIPanGestureRecognizer) {
        let bottomOffset = (descriptionViewInterface?.headerHeight ?? 0) + (contentInset?.bottom ?? 0)
        let movableY = bounds.height - defaultDescriptionTopMargin - bottomOffset
        var moveY = panGestureRecognizer.translationInView(contentContainerView).y
        
        let contentVisible = viewState == .ContentVisible
        
        switch panGestureRecognizer.state {
        case .Changed:
            if contentVisible && moveY < 0 { moveY = 0 }
            else if contentVisible && moveY > movableY { moveY = movableY }
            else if !contentVisible && moveY > 0 { moveY = 0 }
            else if !contentVisible && moveY < -movableY { moveY = -movableY }
            
            let newOffset = contentVisible ? (defaultDescriptionTopMargin - bounds.height) + moveY: -bottomOffset + moveY
            self.contentTopConstraint?.updateOffset(newOffset)
        case .Ended:
            let movedMoreThanHalf = contentVisible && moveY > movableY * 0.5 || !contentVisible && moveY < -movableY * 0.5
            
            let yVelocity = panGestureRecognizer.velocityInView(contentContainerView).y
            let movedFasterForward = contentVisible && yVelocity > descriptionDragVelocityThreshold || !contentVisible && yVelocity < -descriptionDragVelocityThreshold
            let movedFasterBackward = contentVisible && yVelocity < -descriptionDragVelocityThreshold || !contentVisible && yVelocity > descriptionDragVelocityThreshold
            
            if movedFasterForward || (movedMoreThanHalf && !movedFasterBackward) {
                viewState = contentVisible ? .Default : .ContentVisible
            }
            
            updateContentPosition(withAnimation: true, animationDuration: 0.2, forceOffsetUpdate: true)
        default: break
        }
    }
    
    func didTapOnDescriptionView(tapGestureRecognizer: UITapGestureRecognizer) {
        let contentVisible = viewState == .ContentVisible
        viewState = contentVisible ? .Default : .ContentVisible
        updateContentPosition(withAnimation: true, animationDuration: defaultContentAnimationDuration)
    }
    
    func didTapOnImageCollectionView(tapGestureRecognizer: UITapGestureRecognizer) {
        switch viewState {
        case .Default: break //todo go to ImageGallery state
        case .ContentVisible:
            changeViewState(.Default, animated: true)
        case .ImageGallery: break // todo go back to Default state
        }
    }
    
    func didTapShareButton(sender: UIButton) {
        delegate?.pageViewDidTapShareButton(self)
    }
}

extension ProductPageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let touchHandlingDelegate = touch.view as? TouchHandlingDelegate {
            return !touchHandlingDelegate.shouldConsumeTouch(touch)
        }
        if let touchRequiredView = descriptionViewInterface?.touchRequiredView, let touchView = touch.view {
            return !touchView.isDescendantOfView(touchRequiredView)
        }
        return true
    }
}
