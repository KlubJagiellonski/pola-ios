import Foundation
import UIKit

class ContentPromoRecommendationsCell: UITableViewCell {
    static let bottomMargin: CGFloat = 25
    static let cellHeight = Dimensions.recommendationItemSize.height + bottomMargin
    
    let viewSwitcher: ViewSwitcher
    let viewSwitcherContentView = UIView()
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        viewSwitcher = ViewSwitcher(successView: viewSwitcherContentView)
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Dimensions.defaultMargin, bottom: 0, right: Dimensions.defaultMargin)
        collectionView.showsHorizontalScrollIndicator = false
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = Dimensions.recommendationItemSize
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 11
        
        viewSwitcherContentView.addSubview(collectionView)
        contentView.addSubview(viewSwitcher)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        viewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(ContentPromoRecommendationsCell.bottomMargin)
        }
    }
}
