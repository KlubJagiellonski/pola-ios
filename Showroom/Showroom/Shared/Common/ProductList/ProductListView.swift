import Foundation
import UIKit

protocol ProductListViewDelegate: class {
    func productListViewDidReachPageEnd(listView: ProductListViewInterface)
    func productListViewDidTapRetryPage(listView: ProductListViewInterface)
    func productListView(listView: ProductListViewInterface, didTapProductAtIndex index: Int)
    func productListView(listView: ProductListViewInterface, didDoubleTapProductAtIndex index: Int)
}

protocol ProductListViewInterface: class, ContentInsetHandler {
    var productListComponent: ProductListComponent { get }
    var switcherState: ViewSwitcherState { get }
    var nextPageState: NextPageState { get }
    var collectionView: UICollectionView { get }
    var productImageWidth: Int { get }
    weak var delegate: ProductListViewDelegate? { get set }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState)
    func updateData(products: [ListProduct], nextPageState: NextPageState)
    func updateNextPageState(nextPageState: NextPageState)
    func moveToPosition(forProductIndex index: Int, animated: Bool)
    func changeSwitcherState(switcherState: ViewSwitcherState, animated: Bool)
}

extension ProductListViewInterface {
    var contentInset: UIEdgeInsets {
        set {
            guard newValue != contentInset else { return }
            collectionView.contentInset = newValue
            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        get {
            return collectionView.contentInset
        }
    }
    var extendedContentInset: UIEdgeInsets? {
        set {
            let inset = newValue ?? UIEdgeInsetsZero
            collectionView.contentInset = inset
            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        get { return collectionView.contentInset }
    }
    
    var nextPageState: NextPageState {
        get { return productListComponent.nextPageState }
    }
    
    var productImageWidth: Int {
        get { return productListComponent.imageWidth }
    }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState) {
        productListComponent.appendData(products, nextPageState: nextPageState)
    }
    
    func updateData(products: [ListProduct], nextPageState: NextPageState) {
        productListComponent.updateData(products, nextPageState: nextPageState)
    }
    
    func updateNextPageState(nextPageState: NextPageState) {
        productListComponent.updateNextPageState(nextPageState)
    }
    
    func moveToPosition(forProductIndex index: Int, animated: Bool) {
        productListComponent.moveToPosition(forProductIndex: index, animated: animated)
    }
    
    func imageTag(forIndex index: Int) -> Int {
        return productListComponent.imageTag(forIndex: index)
    }
}

extension ProductListComponentDelegate where Self: ProductListViewInterface {
    func productListComponentWillDisplayNextPage(component: ProductListComponent) {
        delegate?.productListViewDidReachPageEnd(self)
    }
    
    func productListComponentDidTapRetryPage(component: ProductListComponent) {
        delegate?.productListViewDidTapRetryPage(self)
    }
    
    func productListComponent(component: ProductListComponent, didTapProductAtIndex index: Int) {
        delegate?.productListView(self, didTapProductAtIndex: index)
    }
    
    func productListComponent(component: ProductListComponent, didDoubleTapProductAtIndex index: Int) {
        delegate?.productListView(self, didDoubleTapProductAtIndex: index)
    }
}

extension UICollectionView {
    func applyProductListConfiguration() {
        backgroundColor = UIColor(named: .White)
        showsVerticalScrollIndicator = false
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
    }
}