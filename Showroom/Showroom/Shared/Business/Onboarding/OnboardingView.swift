import UIKit

protocol OnboardingViewDelegate: class {
    func onboardingDidTapAskForNotification(view: OnboardingView)
    func onboardingDidTapSkip(view: OnboardingView)
}

final class OnboardingView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = HorizontalPageControl()
    
    private let dataSource: OnboardingDataSource
    weak var delegate: OnboardingViewDelegate?
    
    var currentPageIndex: Int {
        let pageWidth = collectionView.frame.width
        return Int(collectionView.contentOffset.x / pageWidth)
    }
    
    init() {
        dataSource = OnboardingDataSource(collectionView: collectionView)
        super.init(frame: CGRectZero)
        
        dataSource.onboardingView = self
        
        collectionView.backgroundColor = UIColor(named: .White)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        pageControl.numberOfPages = dataSource.pagesCount
        pageControl.currentPage = 0
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        configureCustomConstraits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAskForNotification() {
        delegate?.onboardingDidTapAskForNotification(self)
    }
    
    func didTapSkip() {
        delegate?.onboardingDidTapSkip(self)
    }
    
    private func configureCustomConstraits() {
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(37.0)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if cell is OnboardingDoubleTapAnimationCell {
            (cell as! OnboardingDoubleTapAnimationCell).animating = true
        }
    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if cell is OnboardingDoubleTapAnimationCell {
            (cell as! OnboardingDoubleTapAnimationCell).animating = false
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = currentPageIndex
    }

}