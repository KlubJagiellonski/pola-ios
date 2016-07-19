import Foundation
import UIKit

protocol SearchPageHandler: class {
    func page(forIndex index: Int) -> UIView
    func pageAdded(forIndex index: Int)
}

final class SearchDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    var pageCount = 0 {
        didSet {
            collectionView?.reloadData()
        }
    }
    var pageHandler: SearchPageHandler?
    
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        collectionView.registerClass(SearchPageCell.self, forCellWithReuseIdentifier: String(SearchPageCell))
    }
    
    func scrollToPage(atIndex index: Int, animated: Bool) {
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .Left, animated: animated)
    }
    
    //MARK:- UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(SearchPageCell), forIndexPath: indexPath) as! SearchPageCell
        cell.pageView = pageHandler?.page(forIndex: indexPath.item)
        pageHandler?.pageAdded(forIndex: indexPath.item)
        return cell
    }
}
