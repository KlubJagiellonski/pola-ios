import Foundation
import UIKit

protocol PromoSlideshowViewDelegate: ViewSwitcherDelegate {
    func promoSlideshowDidTapClose(promoSlideshow: PromoSlideshowView)
    func promoSlideshowWillBeginPageChanging(promoSlideshow: PromoSlideshowView)
    func promoSlideshowDidEndPageChanging(promoSlideshow: PromoSlideshowView, fromUserAction: Bool, afterLeftBounce: Bool)
    func promoSlideshowView(promoSlideshow: PromoSlideshowView, didChangePlayingState playing: Bool)
    func promoSlideshowDidEndTransitionAnimation(promoSlideshow: PromoSlideshowView)
}

enum PromoSlideshowCloseButtonState {
    case Close
    case Dismiss
    case Play
}

final class PromoSlideshowView: UIView, UICollectionViewDelegate, ModalPanDismissable {
    private let moveToNextPageAnimationDuration: Double = 0.75
    
    private let closeButton = UIButton(type: .Custom)
    private let viewSwitcher: ViewSwitcher
    private let contentView = UIView()
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let progressView = PromoSlideshowProgressView()
    private var transitionLoaderView: UIView?
    private var transitionView: UIView?
    
    private let dataSource: PromoSlideshowDataSource
    var pageHandler: PromoSlideshowPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    var currentPageIndex: Int { return collectionView.currentPageIndex }
    private(set) var closeButtonState: PromoSlideshowCloseButtonState = .Close {
        didSet {
            closeButton.imageView?.layer.removeAllAnimations()
            switch closeButtonState {
            case .Close:
                closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
            case .Dismiss:
                closeButton.setImage(UIImage(asset: .Ic_chevron_down), forState: .Normal)
            case .Play:
                closeButton.setImage(UIImage(asset: .Play_back), forState: .Normal)
            }
        }
    }
    var progressEnded = false {
        didSet {
            progressView.alpha = shouldProgressBeVisible ? 1 : 0
            collectionView.scrollEnabled = !progressEnded && viewState != .PausedWithDetailContent && viewState != .PausedWithFullscreenContent
        }
    }
    var viewState: PromoPageViewState = .Playing {
        didSet {
            logInfo("view state: \(viewState)")
            if oldValue.isPlayingState != viewState.isPlayingState {
                delegate?.promoSlideshowView(self, didChangePlayingState: viewState.isPlayingState)
            }
            
            if viewState == .Playing || viewState == .PausedWithDetailContent {
                closeButtonState = viewState == .Playing ? .Close : .Dismiss
            } else if viewState.isPausedState {
                closeButtonState = .Play
            }
            
            closeButton.alpha = viewState == .PausedWithFullscreenContent ? 0 : 1
            progressView.alpha = shouldProgressBeVisible ? 1 : 0
            collectionView.scrollEnabled = !progressEnded && viewState != .PausedWithDetailContent && viewState != .PausedWithFullscreenContent
        }
    }
    var pageCount: Int { return dataSource.pageCount }
    var viewSwitcherAnimationDuration: Double { return viewSwitcher.animationDuration }
    var viewSwitcherState: ViewSwitcherState { return viewSwitcher.switcherState }
    var shouldProgressBeVisible: Bool {
        if progressEnded {
            return false
        } else if let pausedProgressViewVisible = viewState.isPausedProgressViewVisible {
            return pausedProgressViewVisible
        } else {
            return viewState == .Playing
        }
    }
    var transitionViewVisible: Bool { return transitionView != nil }
    private var panGestureRecognizer: UIPanGestureRecognizer {
        return gestureRecognizers!.find { $0 is UIPanGestureRecognizer } as! UIPanGestureRecognizer
    }
    var transitionAnimationInProgress = false
    weak var delegate: PromoSlideshowViewDelegate? {
        didSet {
            viewSwitcher.switcherDelegate = delegate
        }
    }
    weak var modalPanDismissDelegate: ModalPanDismissDelegate?
    
    init() {
        viewSwitcher = ViewSwitcher(successView: contentView)
        dataSource = PromoSlideshowDataSource(with: collectionView)
        super.init(frame: CGRectZero)
        
        viewSwitcher.switcherDataSource = self
        
        backgroundColor = UIColor(named: .White)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didReceivePanGesture))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.configureForPaging(withDirection: .Horizontal)
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchingEnabled = false
        }
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.applyCircleStyle()
        closeButton.addTarget(self, action: #selector(PromoSlideshowView.onCloseButtonTapped), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(progressView)
        
        addSubview(viewSwitcher)
        addSubview(closeButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSwitcherState(switcherState: ViewSwitcherState, animated: Bool = true) {
        viewSwitcher.changeSwitcherState(switcherState, animated: animated)
    }
    
    func update(with promoSlideshow: PromoSlideshow) {
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        dataSource.pageCount = promoSlideshow.pageCount
        progressView.update(with: promoSlideshow.video)
    }
    
    func update(with progress: ProgressInfoState) {
        progressView.update(with: progress)
    }
    
    func update(with newState: PromoPageViewState, animationDuration: Double?) {
        guard viewState != newState else { return }
        
        layoutIfNeeded()
        UIView.animateWithDuration(animationDuration ?? 0, delay: 0, options: [.CurveEaseInOut], animations: {
            self.viewState = newState
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func moveToNextPage() -> Bool {
        logInfo("move to next page")
        
        guard currentPageIndex != (dataSource.pageCount - 1) else {
            return false
        }
        
        let pageWidth = self.collectionView.frame.width
        let nextIndex = self.currentPageIndex + 1
        
        userInteractionEnabled = false
        self.delegate?.promoSlideshowWillBeginPageChanging(self)
        
        UIView.animateWithDuration(moveToNextPageAnimationDuration, animations: {
            // setting offset to next page - 1 pixel; this way we avoid dequeuing previous cell
            self.collectionView.setContentOffset(CGPointMake(pageWidth * CGFloat(nextIndex) - 1, 0), animated: false)
            
            }, completion: { _ in
            // adjusting offset to next page
            self.collectionView.setContentOffset(CGPointMake(pageWidth * CGFloat(nextIndex), 0), animated: false)
            self.userInteractionEnabled = true
            self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: false, afterLeftBounce: false)
        })
        return true
    }
    
    func pageIndex(forView view: UIView) -> Int? {
        return dataSource.pageIndex(forView: view)
    }
    
    func showTransitionLoader() {
        let loadingIndicator = LoadingIndicator(frame: CGRectZero)
        
        let transitionLoaderView = UIView()
        transitionLoaderView.alpha = 0
        transitionLoaderView.backgroundColor = UIColor(named: .Dim)
        transitionLoaderView.addSubview(loadingIndicator)
        insertSubview(transitionLoaderView, belowSubview: closeButton)
        
        loadingIndicator.snp_makeConstraints { make in make.center.equalToSuperview() }
        transitionLoaderView.snp_makeConstraints { make in make.edges.equalToSuperview() }
        
        UIView.animateWithDuration(viewSwitcher.animationDuration) {
            transitionLoaderView.alpha = 1
        }
        
        loadingIndicator.startAnimation()
        self.transitionLoaderView = transitionLoaderView
    }
    
    func hideTransitionViewIfNeeded() {
        guard let transitionView = transitionView else { return }
        
        transitionLoaderView?.layer.removeAllAnimations()
        transitionLoaderView?.alpha = 1
        
        let scaleFactor: CGFloat = 2
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        UIView.animateWithDuration(viewSwitcher.animationDuration, delay: 0, options: [], animations: { [unowned self]in
            transitionView.alpha = 0
            transitionView.transform = scaleTransform
            transitionView.center = CGPoint(x: transitionView.frame.midX, y: transitionView.frame.midY)
            self.transitionLoaderView?.alpha = 0
        }) { [weak self]_ in
            guard let `self` = self else { return }
            transitionView.removeFromSuperview()
            self.transitionView = nil
            self.transitionLoaderView?.removeFromSuperview()
            self.transitionLoaderView = nil
        }
    }
    
    func runPlayFeedback() {
        guard let imageView = self.closeButton.imageView else { return }
        
        let animationDuration: Double = 0.8
        let scaleFactor: CGFloat = 1.5
        let scaledTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        let defaultTransform = CGAffineTransformIdentity
        
        let animations = {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25) {
                imageView.transform = scaledTransform
            }
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.25) {
                imageView.transform = defaultTransform
            }
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.25) {
                imageView.transform = scaledTransform
            }
            UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25) {
                imageView.transform = defaultTransform
            }
        }
        
        UIView.animateKeyframesWithDuration(animationDuration, delay: 1, options: [], animations: animations ) { success in
            guard success else { return }
            UIView.animateKeyframesWithDuration(animationDuration, delay: 2, options: [], animations: animations, completion: nil)
        }
    }
    
    private func configureCustomConstraints() {
        closeButton.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(Dimensions.modalTopMargin)
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(closeButton.snp_width)
        }
        
        viewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc private func onCloseButtonTapped(button: UIButton) {
        delegate?.promoSlideshowDidTapClose(self)
    }
    
    @objc private func didReceivePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(self)
        let velocity = gestureRecognizer.velocityInView(self)
        modalPanDismissDelegate?.modalPanDidMove(withTranslation: translation, velocity: velocity, state: gestureRecognizer.state)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return CGSize(width: size.width, height: size.height)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        logInfo("scroll view will begin dragging")
        userInteractionEnabled = false
        self.delegate?.promoSlideshowWillBeginPageChanging(self)
    }
    
    private var scrollViewWillLeftBounce: Bool = false
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            scrollViewWillLeftBounce = scrollView.contentOffset.x < 0
        } else {
            self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: true, afterLeftBounce: false)
            userInteractionEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        logInfo("scroll view did end decelerating")
        self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: true, afterLeftBounce: scrollViewWillLeftBounce)
        scrollViewWillLeftBounce = false
        userInteractionEnabled = true
    }
}

extension PromoSlideshowView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}

extension PromoSlideshowView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == collectionView.panGestureRecognizer
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.isEqual(panGestureRecognizer) else { return false }
        guard gestureRecognizer.numberOfTouches() > 0 else { return false }
        
        let translation = panGestureRecognizer.velocityInView(self.collectionView)
        return fabs(translation.y) > fabs(translation.x) && translation.y > 0
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == collectionView.panGestureRecognizer
    }
}

extension PromoSlideshowView: SlideshowImageAnimationTargetViewInterface {
    var viewsAboveImageVisibility: Bool {
        set {
            closeButton.alpha = newValue ? 1 : 0
        }
        get {
            return closeButton.alpha == 1
        }
    }
    
    func addTransitionView(view: UIView) {
        transitionView = view
        
        insertSubview(view, belowSubview: closeButton)
        view.snp_makeConstraints { make in make.edges.equalToSuperview() }
        
        delegate?.promoSlideshowDidEndTransitionAnimation(self)
    }
}

extension PromoSlideshow {
    var containsPlaylist: Bool {
        return !playlist.isEmpty
    }
    
    var pageCount: Int {
        return video.steps.count + (containsPlaylist ? 1 : 0)
    }
    
    var summaryPageIndex: Int? {
        return containsPlaylist ? video.steps.count : nil
    }
}
