import Foundation
import UIKit

class ProductRecommendationCell: UICollectionViewCell {
    static let imageSize: CGSize = CGSizeMake(Dimensions.recommendationItemSize.width, 154)
    
    let productImageView = UIImageView()
    let brandLabel = UILabel()
    let nameLabel = UILabel()
    let basePriceLabel = UILabel()
    let priceLabel = UILabel()
    let priceDiscountBadgeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .ScaleAspectFill
        
        brandLabel.font = UIFont(fontType: .RecommendedBrand)
        brandLabel.textColor = UIColor(named: .Black)
        brandLabel.numberOfLines = 2
        brandLabel.preferredMaxLayoutWidth = Dimensions.recommendationItemSize.width
        
        nameLabel.font = UIFont(fontType: .Recommended)
        nameLabel.textColor = UIColor(named: .Black)
        nameLabel.numberOfLines = 3
        nameLabel.preferredMaxLayoutWidth = Dimensions.recommendationItemSize.width
        nameLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
        
        basePriceLabel.font = UIFont(fontType: .Recommended)
        basePriceLabel.textColor = UIColor(named: .DarkGray)
        
        priceLabel.font = UIFont(fontType: .Recommended)
        priceLabel.textColor = UIColor(named: .Black)
        
        priceDiscountBadgeLabel.backgroundColor = UIColor(named: .RedViolet)
        priceDiscountBadgeLabel.font = UIFont(fontType: .Badge)
        priceDiscountBadgeLabel.textColor = UIColor(named: .White)
        priceDiscountBadgeLabel.textAlignment = .Center
        priceDiscountBadgeLabel.hidden = true
        
        contentView.addSubview(productImageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceDiscountBadgeLabel)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //we need to make name label smaller (by changing number of lines), when it is overlapping base price or price label
        let nameMaxY = CGRectGetMinY(nameLabel.frame) + nameLabel.text!.heightWithConstrainedWidth(nameLabel.bounds.width, font: nameLabel.font)
        let nameOverlappingPriceLabel = nameMaxY > CGRectGetMinY(priceLabel.frame)
        let nameOverlappingBasePriceLabel = isBasePriceVisible() && nameMaxY > CGRectGetMinY(basePriceLabel.frame)
        if nameOverlappingPriceLabel && nameOverlappingBasePriceLabel {
            nameLabel.numberOfLines = 1
        } else if nameOverlappingPriceLabel || nameOverlappingBasePriceLabel {
            nameLabel.numberOfLines = 2
        } else {
            nameLabel.numberOfLines = 3
        }
    }
    
    func updateData(recommendation: ProductRecommendation) {
        productImageView.image = nil
        productImageView.loadImageFromUrl(recommendation.imageUrl, size: ProductRecommendationCell.imageSize)
        brandLabel.text = recommendation.brand
        nameLabel.text = recommendation.title
        priceLabel.text = recommendation.price.stringValue
        basePriceLabel.attributedText = createStrikethroughPriceString(recommendation.basePrice.stringValue)
        
        let priceDiscount = recommendation.price.calculateDiscountPercent(fromMoney: recommendation.basePrice)
        priceDiscountBadgeLabel.hidden = priceDiscount == 0
        priceDiscountBadgeLabel.text = "-\(priceDiscount)%"
        
        if changeBasePriceVisibilityIfNeeded(recommendation) {
            setNeedsUpdateConstraints()
        }
    }

    override func updateConstraints() {
        contentView.snp_remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productImageView.snp_remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(ProductRecommendationCell.imageSize.height)
        }
        
        priceDiscountBadgeLabel.snp_remakeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(31)
            make.height.equalTo(15)
        }
        
        brandLabel.snp_remakeConstraints { make in
            make.top.equalTo(productImageView.snp_bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        if isBasePriceVisible() {
            nameLabel.snp_remakeConstraints { make in
                make.top.equalTo(brandLabel.snp_bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.lessThanOrEqualTo(basePriceLabel.snp_top).priorityLow()
            }
            basePriceLabel.snp_remakeConstraints { make in
                make.bottom.equalTo(priceLabel.snp_top)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        } else {
            nameLabel.snp_remakeConstraints { make in
                make.top.equalTo(brandLabel.snp_bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.lessThanOrEqualTo(priceLabel.snp_top)
            }
            basePriceLabel.snp_removeConstraints()
        }
        
        priceLabel.snp_remakeConstraints { make in
            make.bottom.equalToSuperview().inset(8).priorityHigh()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        super.updateConstraints()
    }
    
    // MARK: - Utilities
    func isBasePriceVisible() -> Bool {
        return basePriceLabel.superview != nil
    }
    
    func changeBasePriceVisibilityIfNeeded(recommendation: ProductRecommendation) -> Bool {
        let basePriceVisible = recommendation.price != recommendation.basePrice
        let previousBasePriceVisible = isBasePriceVisible()
        if basePriceVisible && !previousBasePriceVisible {
            contentView.addSubview(basePriceLabel)
            return true
        } else if !basePriceVisible && previousBasePriceVisible {
            basePriceLabel.removeFromSuperview()
            return true
        }
        return false
    }
    
    func createStrikethroughPriceString(text: String) -> NSAttributedString {
        let attributes: [String: AnyObject] = [
            NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSStrikethroughColorAttributeName: UIColor(named: .DarkGray)
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
