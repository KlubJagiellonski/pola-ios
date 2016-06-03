import Foundation
import UIKit

protocol ProductDetailsPageHandler: class {
    func page(forIndex index: Int, removePageIndex: Int) -> UIView
    func pageAdded(forIndex index: Int, removePageIndex: Int)
}

class ProductDetailsDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var collectionView: UICollectionView?
    
    var pageCount = 0 {
        didSet {
            collectionView?.reloadData()
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
        if indexPath.row == cell.tag && cell.pageView != nil {
            return cell
        }
        cell.pageView = pageHandler?.page(forIndex: indexPath.row, removePageIndex: cell.tag)
        pageHandler?.pageAdded(forIndex: indexPath.row, removePageIndex: cell.tag)
        cell.tag = indexPath.row
        return cell
    }
}
