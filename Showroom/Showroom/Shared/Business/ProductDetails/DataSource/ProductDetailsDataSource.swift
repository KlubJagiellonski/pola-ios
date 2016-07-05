import Foundation
import UIKit

protocol ProductDetailsPageHandler: class {
    func page(forIndex index: Int, removePageIndex: Int?) -> UIView
    func pageAdded(forIndex index: Int, removePageIndex: Int?)
}

class ProductDetailsDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var collectionView: UICollectionView?
    
    var pageCount = 0 {
        didSet {
            if oldValue > pageCount || oldValue == 0 {
                collectionView?.reloadData()
            } else {
                var insertIndexPaths: [NSIndexPath] = []
                for index in oldValue...(pageCount - 1) {
                    insertIndexPaths.append(NSIndexPath(forItem: index, inSection: 0))
                }
                collectionView?.insertItemsAtIndexPaths(insertIndexPaths)
            }
        }
    }
    
    var pageHandler: ProductDetailsPageHandler?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.registerClass(ProductDetailsCell.self, forCellWithReuseIdentifier: String(ProductDetailsCell))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductDetailsCell), forIndexPath: indexPath) as! ProductDetailsCell
        cell.pageView = pageHandler?.page(forIndex: indexPath.row, removePageIndex: pageIndex(fromTag: cell.tag))
        pageHandler?.pageAdded(forIndex: indexPath.row, removePageIndex: pageIndex(fromTag: cell.tag))
        cell.tag = tag(fromIndexPath: indexPath)
        return cell
    }
    
    func tag(fromIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.row + 1
    }
    
    func pageIndex(fromTag tag: Int) -> Int? {
        if tag == 0 {
            return nil
        }
        return tag - 1
    }
}
