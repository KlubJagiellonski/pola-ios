import Foundation
import UIKit

class ProductRecommendationDataSource: NSObject, UICollectionViewDataSource {
    private var productRecommendations: [ProductRecommendation] = []
    weak var collectionView: UICollectionView? {
        didSet {
            guard oldValue != collectionView else { return }
            
            collectionView?.registerClass(ProductRecommendationCell.self, forCellWithReuseIdentifier: String(ProductRecommendationCell))
        }
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