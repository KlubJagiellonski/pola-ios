import UIKit

final class WishlistCell: UITableViewCell {
    static let cellHeight: CGFloat = 148
    static let photoSize: CGSize = CGSizeMake(115, 148)
    
    private let photoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = PriceLabel()
    
    private let topBadgeStackView = UIStackView()
    private let bottomBadgeStackView = UIStackView()
    
    private let priceDiscountBadgeLabel = BadgeLabel(withType: .Discount)
    private let freeDeliveryBadgeLabel = BadgeLabel(withType: .FreeDelivery)
    
    private let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        photoImageView.contentMode = .ScaleAspectFill
        
        brandLabel.backgroundColor = UIColor(named: .White)
        brandLabel.numberOfLines = 2
        brandLabel.font = UIFont.latoHeavy(ofSize: 14)
        
        nameLabel.backgroundColor = UIColor(named: .White)
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.latoRegular(ofSize: 13)
        
        topBadgeStackView.axis = .Vertical
        topBadgeStackView.spacing = 4
        topBadgeStackView.addArrangedSubview(priceDiscountBadgeLabel)
        
        bottomBadgeStackView.axis = .Vertical
        bottomBadgeStackView.spacing = 0
        bottomBadgeStackView.addArrangedSubview(freeDeliveryBadgeLabel)
        
        separatorView.backgroundColor = UIColor(named: ColorName.Separator)
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(topBadgeStackView)
        contentView.addSubview(bottomBadgeStackView)
        contentView.addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshImageIfNeeded(withUrl url: String) {
        if !photoImageView.imageDownloadingInProgress {
            photoImageView.loadImageFromUrl(url, width: WishlistCell.photoSize.width)
        }
    }
    
    func updateData(with product: WishlistProduct) {
        brandLabel.text = product.brand.name
        nameLabel.text = product.name
        photoImageView.image = nil
        photoImageView.loadImageFromUrl(product.imageUrl, width: WishlistCell.photoSize.width)
        priceLabel.basePrice = product.basePrice
        priceLabel.discountPrice = product.basePrice != product.price ? product.price : nil
        
        freeDeliveryBadgeLabel.hidden = !product.freeDelivery
        let priceDiscount = product.price.calculateDiscountPercent(fromMoney: product.basePrice)
        priceDiscountBadgeLabel.hidden = priceDiscount == 0
        priceDiscountBadgeLabel.text = "-\(priceDiscount)%"
    }
    
    private func configureCustomConstraints() {
        photoImageView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(WishlistCell.photoSize)
        }
        
        brandLabel.snp_makeConstraints { make in
            make.left.equalTo(photoImageView.snp_right).offset(Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(7)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        nameLabel.snp_makeConstraints { make in
            make.left.equalTo(brandLabel)
            make.top.equalTo(brandLabel.snp_bottom).offset(3)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        priceLabel.snp_makeConstraints { make in
            make.left.equalTo(brandLabel)
            make.bottom.equalToSuperview().inset(30)
        }
        
        separatorView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        topBadgeStackView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalTo(photoImageView)
        }
        
        bottomBadgeStackView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(photoImageView)
        }
    }
}