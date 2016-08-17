import Foundation
import UIKit

protocol ProductItemCellDelegate : class {
    func productItemCellDidTap(cell: ProductItemCell)
    func productItemCellDidDoubleTap(cell: ProductItemCell)
}

final class ProductItemCell: UICollectionViewCell {
    //when cell width is smaller than this value it is possible that basePrice and price (5 digit) will overlap each other. Then we have to change kerning of base price to make it look better
    private static let changingKernForBasePriceViewWidthThreshold: CGFloat = 124
    private static let doubleTapDelay: NSTimeInterval = 0.2
    
    weak var delegate: ProductItemCellDelegate?
    var imageTag: Int {
        set { productImageView.tag = newValue }
        get { return productImageView.tag }
    }
    
    private let productImageView = UIImageView()
    private let brandLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let topBadgeStackView = UIStackView()
    private let bottomBadgeStackView = UIStackView()
    
    private let newBadgeLabel = BadgeLabel(withType: .New)
    private let priceDiscountBadgeLabel = BadgeLabel(withType: .Discount)
    private let freeDeliveryBadgeLabel = BadgeLabel(withType: .FreeDelivery)
    private let premiumBadgeLabel = BadgeLabel(withType: .Premium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .ScaleAspectFill
        
        brandLabel.font = UIFont(fontType: .ProductListBoldText)
        brandLabel.textColor = UIColor(named: .Black)
        brandLabel.numberOfLines = 2
        brandLabel.preferredMaxLayoutWidth = frame.width
        brandLabel.textAlignment = .Center
        
        nameLabel.font = UIFont(fontType: .ProductListText)
        nameLabel.textColor = UIColor(named: .Black)
        nameLabel.numberOfLines = 2
        nameLabel.preferredMaxLayoutWidth = frame.width
        nameLabel.textAlignment = .Center
        
        priceLabel.font = UIFont(fontType: .ProductListBoldText)
        priceLabel.textColor = UIColor(named: .Black)
        
        topBadgeStackView.axis = .Vertical
        topBadgeStackView.spacing = 4
        topBadgeStackView.addArrangedSubview(newBadgeLabel)
        topBadgeStackView.addArrangedSubview(priceDiscountBadgeLabel)
        
        bottomBadgeStackView.axis = .Vertical
        bottomBadgeStackView.spacing = 0
        bottomBadgeStackView.addArrangedSubview(freeDeliveryBadgeLabel)
        bottomBadgeStackView.addArrangedSubview(premiumBadgeLabel)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(topBadgeStackView)
        contentView.addSubview(bottomBadgeStackView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.tapCount == 2 {
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.tapCount == 1 {
            performSelector(#selector(ProductItemCell.didTapItem), withObject: nil, afterDelay: ProductItemCell.doubleTapDelay)
        } else if touch.tapCount == 2 {
            didDoubleTapItem()
        }
    }
    
    final func didTapItem() {
        delegate?.productItemCellDidTap(self)
    }
    
    private func didDoubleTapItem() {
        delegate?.productItemCellDidDoubleTap(self)
        let heartMaskView = HeartMaskView(frame: self.productImageView.frame)
        contentView.addSubview(heartMaskView)
        heartMaskView.animate(duration: 1) {
            heartMaskView.removeFromSuperview()
        }
    }
    
    final func updateData(with product: ListProduct) {
        productImageView.image = nil
        productImageView.loadImageFromUrl(product.imageUrl, width: bounds.width)
        brandLabel.text = product.brand.name
        nameLabel.text = product.name
        
        let priceValue = product.price.stringValue
        let basePriceValue = product.basePrice.stringValue
        if priceValue != basePriceValue {
            let priceCharactersCount = priceValue.characters.count + basePriceValue.characters.count
            let shouldChangeBasePriceKern = bounds.width < ProductItemCell.changingKernForBasePriceViewWidthThreshold && priceCharactersCount >= 24
            let spaceBetweenPrices = shouldChangeBasePriceKern ? "  " : "   "
            let priceText = "\(priceValue)\(spaceBetweenPrices)\(basePriceValue)"
            priceLabel.attributedText = priceText.stringWithStrikethroughBasePrice(basePriceValue, kern: shouldChangeBasePriceKern ? -0.5 : nil)
        } else {
            priceLabel.text = priceValue
        }
        
        newBadgeLabel.hidden = !product.new
        freeDeliveryBadgeLabel.hidden = !product.freeDelivery
        premiumBadgeLabel.hidden = !product.premium
        let priceDiscount = product.price.calculateDiscountPercent(fromMoney: product.basePrice)
        priceDiscountBadgeLabel.hidden = priceDiscount == 0
        priceDiscountBadgeLabel.text = "-\(priceDiscount)%"
    }
    
    private func configureCustomConstraints() {
        productImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(productImageView.snp_width).dividedBy(Dimensions.defaultImageRatio)
        }
        
        topBadgeStackView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview()
        }
        
        bottomBadgeStackView.snp_makeConstraints { make in
            make.bottom.equalTo(productImageView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        brandLabel.snp_makeConstraints { make in
            make.top.equalTo(productImageView.snp_bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(brandLabel.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(priceLabel.snp_top).offset(-3.5) //please don't ask me why, it's just works. But if you find better solution I will buy beer for you ;)
        }
        
        priceLabel.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}