import UIKit

protocol OnboardingViewDelegate: class {
    func onboardingDidTapAskForNotification(view: OnboardingView)
    func onboardingDidTapSkip(view: OnboardingView)
}

final class OnboardingView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let dataSource: OnboardingDataSource
    weak var delegate: OnboardingViewDelegate?
    
    var currentPageIndex: Int {
        set {
            let pageWidth = collectionView.frame.width
            let contentOffsetX = CGFloat(newValue) * pageWidth
            collectionView.setContentOffset(CGPoint(x: contentOffsetX, y: 0.0), animated: true)
        }
        get {
            let pageWidth = collectionView.frame.width
            return Int(collectionView.contentOffset.x / pageWidth)
        }
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
        
        addSubview(collectionView)
        
        configureCustomConstraits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapNext() {
        currentPageIndex += 1
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
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
}