import Foundation
import UIKit

protocol PromoSlideshowViewDelegate: ViewSwitcherDelegate {
    func promoSlideshowDidTapClose(promoSlideshow: PromoSlideshowView)
    func promoSlideshowWillBeginPageChanging(promoSlideshow: PromoSlideshowView)
    func promoSlideshowDidEndPageChanging(promoSlideshow: PromoSlideshowView, fromUserAction: Bool)
    func promoSlideshowView(promoSlideshow: PromoSlideshowView, didChangePlayingState playing: Bool)
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
    
    private let dataSource: PromoSlideshowDataSource
    var pageHandler: PromoSlideshowPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    var currentPageIndex: Int { return collectionView.currentPageIndex }
    private(set) var closeButtonState: PromoSlideshowCloseButtonState = .Close {
        didSet {
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
    var shouldProgressBeVisible: Bool {
        if progressEnded {
            return false
        } else if let pausedProgressViewVisible = viewState.isPausedProgressViewVisible {
            return pausedProgressViewVisible
        } else {
            return viewState == .Playing
        }
    }
    private var panGestureRecognizer: UIPanGestureRecognizer {
        return gestureRecognizers!.find { $0 is UIPanGestureRecognizer } as! UIPanGestureRecognizer
    }
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
            self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: false)
        })
        return true
    }
    
    func pageIndex(forView view: UIView) -> Int? {
        return dataSource.pageIndex(forView: view)
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: true)
            userInteractionEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        logInfo("scroll view did end decelerating")
        self.delegate?.promoSlideshowDidEndPageChanging(self, fromUserAction: true)
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
