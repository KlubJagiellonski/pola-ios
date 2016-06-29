import Foundation
import UIKit

protocol ProductItemCellDelegate : class {
    func productItemCellDidTap(cell: ProductItemCell)
    func productItemCellDidDoubleTap(cell: ProductItemCell)
}

final class ProductItemCell: UICollectionViewCell {
    //when cell width is smaller than this value it is possible that basePrice and price (5 digit) will overlap each other. Then we have to change kerning of base price to make it look better
    private let changingKernForBasePriceViewWidthThreshold: CGFloat = 124
    
    weak var delegate: ProductItemCellDelegate?
    
    private let productImageView = UIImageView()
    private let brandLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceRow = ProductItemPriceRow()
    private let topBadgeStackView = UIStackView()
    private let bottomBadgeStackView = UIStackView()
    
    private let newBadgeLabel = BadgeLabel(withType: .New)
    private let priceDiscountBadgeLabel = BadgeLabel(withType: .Discount)
    private let freeDeliveryBadgeLabel = BadgeLabel(withType: .FreeDelivery)
    private let premiumBadgeLabel = BadgeLabel(withType: .Premium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapItem))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(doubleTapGestureRecognizer)
        
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .ScaleAspectFill
        
        brandLabel.font = UIFont(fontType: .ProductListBoldText)
        brandLabel.textColor = UIColor(named: .Black)
        brandLabel.numberOfLines = 2
        brandLabel.preferredMaxLayoutWidth = frame.width
        
        nameLabel.font = UIFont(fontType: .ProductListText)
        nameLabel.textColor = UIColor(named: .Black)
        nameLabel.numberOfLines = 2
        nameLabel.preferredMaxLayoutWidth = frame.width
        
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
        contentView.addSubview(priceRow)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapItem() {
        delegate?.productItemCellDidTap(self)
    }
    
    func didDoubleTapItem() {
        delegate?.productItemCellDidDoubleTap(self)
    }
    
    func updateData(with product: Product) {
        productImageView.image = nil
        productImageView.loadImageFromUrl(product.imageUrl, w: bounds.width)
        brandLabel.text = product.brand
        nameLabel.text = product.name
        priceRow.basePriceLabel.hidden = product.basePrice == product.price
        
        let priceValue = product.price.stringValue
        let basePriceValue = product.basePrice.stringValue
        let basePriceStrikethrough = basePriceValue.createStrikethroughString(UIColor(named: .DarkGray))
        let priceCharactersCount = priceValue.characters.count + basePriceValue.characters.count
        let shouldChangeBasePriceKern = bounds.width < changingKernForBasePriceViewWidthThreshold && !priceRow.basePriceLabel.hidden && priceCharactersCount >= 24
        if shouldChangeBasePriceKern {
            basePriceStrikethrough.addAttribute(NSKernAttributeName, value: -0.3, range: NSMakeRange(0, basePriceValue.characters.count))
        }
        priceRow.priceLabel.text = priceValue
        priceRow.basePriceLabel.attributedText = basePriceStrikethrough
        
        
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
            make.bottom.lessThanOrEqualTo(priceRow.snp_top).offset(-3.5) //please don't ask me why, it's just works. But if you find better solution I will buy beer for you ;)
        }
        
        priceRow.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

final class ProductItemPriceRow: UIView {
    private let basePriceLabel = UILabel()
    private let priceLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        
        basePriceLabel.font = UIFont(fontType: .ProductListText)
        basePriceLabel.textColor = UIColor(named: .DarkGray)
        
        priceLabel.font = UIFont(fontType: .ProductListBoldText)
        priceLabel.textColor = UIColor(named: .Black)
        
        addSubview(basePriceLabel)
        addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        priceLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        basePriceLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, priceLabel.intrinsicContentSize().height)
    }
}