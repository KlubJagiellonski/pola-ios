import Foundation
import UIKit

protocol PromoSlideshowViewDelegate: ViewSwitcherDelegate {
    func promoSlideshowDidTapClose(promoSlideshow: PromoSlideshowView)
}

final class PromoSlideshowView: ViewSwitcher, UICollectionViewDelegate {
    private let contentView = UIView()
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let progressView = PromoSlideshowProgressView()
    private let closeButton = UIButton(type: .Custom)
    
    private let dataSource: PromoSlideshowDataSource
    var pageHandler: PromoSlideshowPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    var currentPageIndex: Int {
        let pageWidth = collectionView.frame.width
        return Int(collectionView.contentOffset.x / pageWidth)
    }
    weak var delegate: PromoSlideshowViewDelegate? {
        didSet {
            switcherDelegate = delegate
        }
    }
    
    init() {
        dataSource = PromoSlideshowDataSource(with: collectionView)
        super.init(successView: contentView)
        
        switcherDataSource = self
        
        backgroundColor = UIColor(named: .White)
        
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.applyCircleStyle()
        closeButton.addTarget(self, action: #selector(PromoSlideshowView.onCloseButtonTapped), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(progressView)
        contentView.addSubview(closeButton)
        
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
    
    func update(with state: PromoPageViewState, animationDuration: Double?) {
        //TODO: update view state
    }
    
    func moveToNextPage() {
        let indexPath = NSIndexPath(forItem: currentPageIndex + 1, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
    
    private func configureCustomConstraints() {
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        closeButton.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(Dimensions.modalTopMargin)
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(closeButton.snp_width)
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
}

extension PromoSlideshowView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), UIImage(asset: .Error))
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}
