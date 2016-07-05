import Foundation
import UIKit

protocol CategoryProductListViewDelegate: ProductListViewDelegate, ViewSwitcherDelegate {
    
}

class CategoryProductListView: ViewSwitcher, ProductListViewInterface, ProductListComponentDelegate {
    let productListComponent: ProductListComponent
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: ProductListViewDelegate? {
        didSet {
            switcherDelegate = categoryListDelegate
        }
    }
    weak var categoryListDelegate: CategoryProductListViewDelegate? {
        return delegate as? CategoryProductListViewDelegate
    }
    
    init() {
        productListComponent = ProductListComponent(withCollectionView: collectionView)
        super.init(successView: collectionView)
        
        backgroundColor = UIColor(named: .White)
        
        switcherDataSource = self
        productListComponent.delegate = self
        
        collectionView.applyProductListConfiguration()
        collectionView.delegate = productListComponent
        collectionView.dataSource = productListComponent
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryProductListView {
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize) {}
}

extension CategoryProductListView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = ProductListEmptyView()
        emptyView.descriptionText = tr(.ProductListEmptyDescription)
        return emptyView
    }
}

