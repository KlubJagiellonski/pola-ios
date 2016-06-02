import Foundation
import UIKit

class ProductRecommendationCell: UICollectionViewCell {
    static let photoRatio = 0.76
    
    let productImageView = UIImageView()
    let brandLabel = UILabel()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .ScaleAspectFill
        
        brandLabel.font = UIFont(fontType: .RecommendedBrand)
        brandLabel.textColor = UIColor(named: .Black)
        brandLabel.textAlignment = .Center
        brandLabel.numberOfLines = 2
        brandLabel.preferredMaxLayoutWidth = Dimensions.recommendationItemSize.width
        
        nameLabel.font = UIFont(fontType: .Recommended)
        nameLabel.textColor = UIColor(named: .Black)
        nameLabel.textAlignment = .Center
        nameLabel.numberOfLines = 3
        nameLabel.preferredMaxLayoutWidth = Dimensions.recommendationItemSize.width
        
        priceLabel.font = UIFont(fontType: .Recommended)
        priceLabel.textColor = UIColor(named: .Black)
        priceLabel.textAlignment = .Center
        
        addSubview(productImageView)
        addSubview(brandLabel)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(recommendation: ProductRecommendation) {
        let width = contentView.bounds.width
        let imageSize = CGSizeMake(width, ceil(width / CGFloat(ProductRecommendationCell.photoRatio)))
        productImageView.loadImageFromUrl(recommendation.imageUrl, size: imageSize)
        brandLabel.text = recommendation.brand
        nameLabel.text = recommendation.title
        priceLabel.text = recommendation.price.stringValue
    }
    
    func configureCustomConstraints() {
        productImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(productImageView.snp_width).dividedBy(ProductRecommendationCell.photoRatio)
        }
        
        brandLabel.snp_makeConstraints { make in
            make.top.equalTo(productImageView.snp_bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(productImageView.snp_bottom).offset(50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp_makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
