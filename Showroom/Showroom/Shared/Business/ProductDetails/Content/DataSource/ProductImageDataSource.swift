import Foundation
import UIKit

class ProductImageDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    var imageUrls: [String] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        collectionView.registerClass(ProductImageCell.self, forCellWithReuseIdentifier: String(ProductImageCell))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let imageUrl = imageUrls[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductImageCell), forIndexPath: indexPath) as! ProductImageCell
        cell.imageView.image = nil
        cell.imageView.loadImageFromUrl(imageUrl, w: cell.bounds.width)
        return cell
    }
}
