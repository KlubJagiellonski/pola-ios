import UIKit

class OnboardingView: UIView, UICollectionViewDelegateFlowLayout {
    
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let dataSource: OnboardingDataSource
    
    private let pageControl = HorizontalPageControl()
    
    var currentPageIndex: Int {
        let pageWidth = collectionView.frame.width
        return Int(collectionView.contentOffset.x / pageWidth)
    }
    
    init() {
        dataSource = OnboardingDataSource(collectionView: collectionView)
        super.init(frame: CGRectZero)
        
        collectionView.backgroundColor = UIColor(named: .White)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagingEnabled = true

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
    
    func configureCustomConstraits() {
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40.0)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = currentPageIndex
    }

}