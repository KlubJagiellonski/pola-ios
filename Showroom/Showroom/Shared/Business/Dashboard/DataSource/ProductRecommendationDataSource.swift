import Foundation
import UIKit

class ProductRecommendationDataSource: NSObject, UICollectionViewDataSource {
    private var productRecommendations: [ProductRecommendation] = []
    
    var imageWidth: CGFloat {
        return ProductRecommendationCell.imageSize.width
    }
    
    weak var collectionView: UICollectionView? {
        didSet {
            guard oldValue != collectionView else { return }
            
            collectionView?.registerClass(ProductRecommendationCell.self, forCellWithReuseIdentifier: String(ProductRecommendationCell))
        }
    }
    
    func moveToPosition(atIndex index: Int, animated: Bool) {
        guard let view = collectionView else { return }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        view.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    func changeData(productRecommendations: [ProductRecommendation]) {
        //TODO add animations
        self.productRecommendations = productRecommendations
        collectionView?.reloadData()
    }
    
    func getDataForRow(atIndexPath indexPath: NSIndexPath) -> ProductRecommendation {
        return productRecommendations[indexPath.row]
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productRecommendations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let recommendation = productRecommendations[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductRecommendationCell), forIndexPath: indexPath) as! ProductRecommendationCell
        cell.updateData(recommendation)
        return cell
    }
}