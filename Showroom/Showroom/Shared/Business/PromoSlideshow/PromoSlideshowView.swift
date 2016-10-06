import Foundation
import UIKit

protocol PromoSlideshowViewDelegate: ViewSwitcherDelegate {
    func promoSlideshowDidTapClose(promoSlideshow: PromoSlideshowView)
    func promoSlideshowWillBeginPageChanging(promoSlideshow: PromoSlideshowView)
    func promoSlideshowDidEndPageChanging(promoSlideshow: PromoSlideshowView)
}

enum PromoSlideshowCloseButtonState {
    case Close
    case Dismiss
    case Play
}

final class PromoSlideshowView: ViewSwitcher, UICollectionViewDelegate {
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
    var currentPageIndex: Int {
        return collectionView.currentPageIndex
    }
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
    var viewState: PromoPageViewState = .Close {
        didSet {
            if viewState == .Close || viewState == .Dismiss {
                closeButtonState = viewState == .Close ? .Close : .Dismiss
            } else if viewState == .Paused {
                closeButtonState = .Play
            }
            
            closeButton.alpha = viewState == .FullScreen ? 0 : 1
            progressView.alpha = viewState == .Close ? 1 : 0
            collectionView.scrollEnabled = viewState == .Close
        }
    }
    weak var delegate: PromoSlideshowViewDelegate? {
        didSet {
            switcherDelegate = delegate
        }
    }
    
    init() {
        viewSwitcher = ViewSwitcher(successView: contentView)
        dataSource = PromoSlideshowDataSource(with: collectionView)
        super.init(successView: contentView)
        
        switcherDataSource = self
        
        backgroundColor = UIColor(named: .White)
        
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.configureForPaging(withDirection: .Horizontal)
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.applyCircleStyle()
        closeButton.addTarget(self, action: #selector(PromoSlideshowView.onCloseButtonTapped), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(progressView)
        
        addSubview(contentView)
        addSubview(closeButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with promoSlideshow: PromoSlideshow) {
        dataSource.pageCount = promoSlideshow.video.steps.count + 1
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
    
    func moveToNextPage() {
        let indexPath = NSIndexPath(forItem: currentPageIndex + 1, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
        self.delegate?.promoSlideshowWillBeginPageChanging(self)
    }
    
    private func configureCustomConstraints() {
        closeButton.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(Dimensions.modalTopMargin)
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(closeButton.snp_width)
        }
        
        contentView.snp_makeConstraints { make in
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
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return CGSize(width: size.width, height: size.height)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.delegate?.promoSlideshowWillBeginPageChanging(self)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.promoSlideshowDidEndPageChanging(self)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.delegate?.promoSlideshowDidEndPageChanging(self)
    }
}

extension PromoSlideshowView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), UIImage(asset: .Error))
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}
