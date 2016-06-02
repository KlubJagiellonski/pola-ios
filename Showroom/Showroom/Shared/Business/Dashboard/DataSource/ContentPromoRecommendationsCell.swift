import Foundation
import UIKit

class ContentPromoRecommendationsCell: UITableViewCell {
    static let bottomMargin: CGFloat = 25
    static let cellHeight = Dimensions.recommendationItemSize.height + bottomMargin
    
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Dimensions.defaultMargin, bottom: 0, right: Dimensions.defaultMargin)
        collectionView.showsHorizontalScrollIndicator = false
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = Dimensions.recommendationItemSize
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 11
        
        contentView.addSubview(collectionView)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCustomConstraints() {
        collectionView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(ContentPromoRecommendationsCell.bottomMargin)
        }
    }
}
