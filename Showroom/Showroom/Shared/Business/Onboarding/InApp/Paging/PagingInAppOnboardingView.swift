import UIKit

protocol PagingInAppOnboardingViewDelegate: class {
    func pagingOnboardingDidTapDismiss(view: PagingInAppOnboardingView)
}

class PagingInAppOnboardingView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dataSource: PagingInAppOnboardingDataSource
    weak var delegate: PagingInAppOnboardingViewDelegate?
    
    var currentPageIndex: Int {
        set {
            let pageWidth = collectionView.frame.width
            let contentOffsetX = CGFloat(newValue) * pageWidth
            collectionView.setContentOffset(CGPoint(x: contentOffsetX, y: 0.0), animated: true)
        }
        get {
            return collectionView.currentPageIndex
        }
    }    

    init() {
        dataSource = PagingInAppOnboardingDataSource(collectionView: collectionView)
        super.init(frame: CGRectZero)
        
        dataSource.onboardingView = self
        
        collectionView.backgroundColor = UIColor(named: .White)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.scrollEnabled = false
        collectionView.configureForPaging(withDirection: .Horizontal)
        
        addSubview(collectionView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapNext() {
        currentPageIndex += 1
    }
    
    func didTapDismiss() {
        delegate?.pagingOnboardingDidTapDismiss(self)
    }
    
    private func configureCustomConstraints() {
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch cell {
        case let photosCell as InAppOnboardingPhotosPagingCell:
            photosCell.startAnimation()
        case let productsCell as InAppOnboardingProductPagingCell:
            productsCell.startAnimation()
        default: break
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch cell {
        case let photosCell as InAppOnboardingPhotosPagingCell:
            photosCell.stopAnimation()
        case let productsCell as InAppOnboardingProductPagingCell:
            productsCell.stopAnimation()
        default: break
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
}