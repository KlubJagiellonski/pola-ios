import UIKit

protocol TrendProductListViewDelegate: ProductListViewDelegate, ViewSwitcherDelegate {
    
}

class TrendProductListView: ViewSwitcher, ProductListViewInterface, ProductListComponentDelegate {
    let productListComponent: ProductListComponent
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: ProductListViewDelegate? {
        didSet {
            switcherDelegate = trendListDelegate
        }
    }
    weak var trendListDelegate: TrendProductListViewDelegate? {
        return delegate as? TrendProductListViewDelegate
    }
    private let headerCell = TrendHeaderCell()
    private var currentHeaderDescription: NSAttributedString?
    
    init() {
        productListComponent = ProductListComponent(withCollectionView: collectionView)
        super.init(successView: collectionView)
        
        backgroundColor = UIColor(named: .White)
        
        switcherDataSource = self
        
        productListComponent.delegate = self
        productListComponent.headerSectionInfo = HeaderSectionInfo(view: headerCell, wantsToReceiveScrollEvents: true) { [unowned self] in
            guard let headerDescription = self.currentHeaderDescription else { return 0 }
            return TrendHeaderCell.height(forWidth: self.collectionView.bounds.width, andDescription: headerDescription)
        }
        
        collectionView.applyProductListConfiguration()
        collectionView.delegate = productListComponent
        collectionView.dataSource = productListComponent
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTrendInfo(imageUrl: String, description: NSAttributedString) {
        currentHeaderDescription = description
        headerCell.updateData(withImageUrl: imageUrl, description: description)
    }
}

extension TrendProductListView {
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize) {
        guard contentOffset.y < headerCell.bounds.height else { return }
        let contentInset = collectionView.contentInset
        headerCell.updateImagePosition(forYOffset: contentOffset.y + contentInset.top, contentHeight: collectionView.bounds.height - (contentInset.top + contentInset.bottom))
    }
}

extension TrendProductListView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = ProductListEmptyView()
        emptyView.descriptionText = tr(.ProductListEmptyDescription)
        return emptyView
    }
}