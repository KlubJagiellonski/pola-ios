import Foundation
import UIKit

class ProductRecommendationDataSource: NSObject, UICollectionViewDataSource {
    private var productRecommendations: [ProductRecommendation] = []
    
    var imageWidth: Int {
        return UIImageView.scaledImageSize(ProductRecommendationCell.imageSize.width)
    }
    weak var collectionView: UICollectionView? {
        didSet {
            guard oldValue != collectionView else { return }
            
            collectionView?.registerClass(ProductRecommendationCell.self, forCellWithReuseIdentifier: String(ProductRecommendationCell))
        }
    }
    var viewSwitcherState: ViewSwitcherState = .Loading {
        didSet {
            if let viewSwitcher = viewSwitcher {
                viewSwitcher.changeSwitcherState(viewSwitcherState)
            }
        }
    }
    weak var viewSwitcherDelegate: ViewSwitcherDelegate?
    weak var viewSwitcherDataSource: ViewSwitcherDataSource?
    weak var viewSwitcher: ViewSwitcher? {
        didSet {
            if let viewSwitcher = viewSwitcher {
                viewSwitcher.switcherDelegate = viewSwitcherDelegate
                viewSwitcher.switcherDataSource = viewSwitcherDataSource
                viewSwitcher.changeSwitcherState(viewSwitcherState)
            }
        }
    }
    
    func moveToPosition(atIndex index: Int, animated: Bool) {
        guard let view = collectionView else { return }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        view.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    func changeData(productRecommendations: [ProductRecommendation]) {
        self.productRecommendations = productRecommendations
        collectionView?.reloadData()
    }
    
    func getDataForRow(atIndexPath indexPath: NSIndexPath) -> ProductRecommendation {
        return productRecommendations[indexPath.row]
    }
    
    func imageTag(forIndex index: Int) -> Int {
        return "\(productRecommendations[index].itemId) \(index)".hashValue
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productRecommendations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let recommendation = productRecommendations[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductRecommendationCell), forIndexPath: indexPath) as! ProductRecommendationCell
        cell.imageTag = imageTag(forIndex: indexPath.row)
        cell.updateData(recommendation)
        return cell
    }
}