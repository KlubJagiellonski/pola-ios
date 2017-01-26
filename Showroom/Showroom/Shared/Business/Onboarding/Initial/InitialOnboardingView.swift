import UIKit

protocol InitialOnboardingViewDelegate: class {
    func onboardingDidTapAskForNotification(view: InitialOnboardingView)
    func onboardingDidTapSkip(view: InitialOnboardingView)
}

final class InitialOnboardingView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let dataSource: InitialOnboardingDataSource
    weak var delegate: InitialOnboardingViewDelegate?
    
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
        dataSource = InitialOnboardingDataSource(collectionView: collectionView)
        super.init(frame: CGRectZero)
        
        dataSource.onboardingView = self
        
        collectionView.backgroundColor = UIColor(named: .White)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.configureForPaging(withDirection: .Horizontal)
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchingEnabled = false
        }
        
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
