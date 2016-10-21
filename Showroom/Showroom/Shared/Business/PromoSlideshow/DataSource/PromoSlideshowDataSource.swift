import Foundation
import UIKit

protocol PromoSlideshowPageHandler: class {
    func page(forIndex index: Int, removePageIndex: Int?) -> UIView
    func pageAdded(forIndex index: Int, removePageIndex: Int?)
}

final class PromoSlideshowDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    var pageCount = 0 {
        didSet {
            collectionView?.reloadData()
        }
    }
    weak var pageHandler: PromoSlideshowPageHandler?
    
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        collectionView.registerClass(PromoSlideshowPageCell.self, forCellWithReuseIdentifier: String(PromoSlideshowPageCell))
    }
    
    func pageIndex(forView view: UIView) -> Int? {
        guard let collectionView = collectionView else {
            logError("Cannot find page index when collectionView not exist")
            return nil
        }
        
        for cell in collectionView.visibleCells() {
            guard let pageCell = cell as? PromoSlideshowPageCell else {
                continue
            }
            if pageCell.pageView == view {
                return collectionView.indexPathForCell(pageCell)?.row
            }
        }
        return nil
    }
    
    private func tag(fromIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.row + 1
    }
    
    private func pageIndex(fromTag tag: Int) -> Int? {
        if tag == 0 {
            return nil
        }
        return tag - 1
    }
    
    //MARK:- UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(PromoSlideshowPageCell), forIndexPath: indexPath) as! PromoSlideshowPageCell
        cell.pageView = pageHandler?.page(forIndex: indexPath.row, removePageIndex: pageIndex(fromTag: cell.tag))
        pageHandler?.pageAdded(forIndex: indexPath.row, removePageIndex: pageIndex(fromTag: cell.tag))
        cell.tag = tag(fromIndexPath: indexPath)
        return cell
    }
}
