import Foundation
import UIKit
import Haneke

class ProductImageDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    var lowResImageUrl: String?
    var imageUrls: [String] = [] {
        didSet {
            guard oldValue.count != 0 else {
                collectionView?.reloadData()
                return
            }
            if let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? ProductImageCell where oldValue[0] != imageUrls[0] {
                loadImageForFirstItem(imageUrls[0], forCell: cell)
            }
            
            guard imageUrls.count > 1 else { return }
            
            var indexPaths: [NSIndexPath] = []
            for index in 1...(imageUrls.count - 1) {
                indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
            }
            collectionView?.insertItemsAtIndexPaths(indexPaths)
        }
    }
    
    init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        collectionView.registerClass(ProductImageCell.self, forCellWithReuseIdentifier: String(ProductImageCell))
    }
    
    private func loadImageForFirstItem(imageUrl: String, forCell cell: ProductImageCell) {
        cell.imageView.loadImageWithLowResImage(imageUrl, lowResUrl: lowResImageUrl, w: cell.bounds.width)
    }
    
    // MARK:- UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let imageUrl = imageUrls[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductImageCell), forIndexPath: indexPath) as! ProductImageCell
        cell.imageView.image = nil
        if indexPath.row == 0 {
            loadImageForFirstItem(imageUrl, forCell: cell)
        } else {
            cell.imageView.loadImageFromUrl(imageUrl, w: cell.bounds.width)
        }
        
        return cell
    }
}
