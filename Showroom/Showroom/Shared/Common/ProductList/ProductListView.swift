import Foundation
import UIKit

protocol ProductListViewDelegate: class {
    func productListViewDidReachPageEnd(listView: ProductListViewInterface)
    func productListView(listView: ProductListViewInterface, didTapProduct product: ListProduct)
    func productListView(listView: ProductListViewInterface, didDoubleTapProduct product: ListProduct)
}

protocol ProductListViewInterface: class {
    var productListComponent: ProductListComponent { get }
    var switcherState: ViewSwitcherState { get set }
    var nextPageState: NextPageState { get set }
    var contentInset: UIEdgeInsets { get set }
    var collectionView: UICollectionView { get }
    weak var delegate: ProductListViewDelegate? { get set }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState)
    func updateData(products: [ListProduct], nextPageState: NextPageState)
}

extension ProductListViewInterface {
    var contentInset: UIEdgeInsets {
        set {
            collectionView.contentInset = newValue
            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        get { return collectionView.contentInset }
    }
    
    var nextPageState: NextPageState {
        set { productListComponent.nextPageState = newValue }
        get { return productListComponent.nextPageState }
    }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState) {
        productListComponent.appendData(products, nextPageState: nextPageState)
    }
    
    func updateData(products: [ListProduct], nextPageState: NextPageState) {
        productListComponent.updateData(products, nextPageState: nextPageState)
    }
}

extension ProductListComponentDelegate where Self: ProductListViewInterface {
    func productListComponentWillDisplayNextPage(component: ProductListComponent) {
        delegate?.productListViewDidReachPageEnd(self)
    }
    
    func productListComponent(component: ProductListComponent, didTapProduct product: ListProduct) {
        delegate?.productListView(self, didTapProduct: product)
    }
    
    func productListComponent(component: ProductListComponent, didDoubleTapProduct product: ListProduct) {
        delegate?.productListView(self, didDoubleTapProduct: product)
    }
}

extension UICollectionView {
    func applyProductListConfiguration() {
        backgroundColor = UIColor(named: .White)
        showsVerticalScrollIndicator = false
    }
}