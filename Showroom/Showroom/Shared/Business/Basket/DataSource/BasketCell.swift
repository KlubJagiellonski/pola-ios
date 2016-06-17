import Foundation
import UIKit

protocol BasketProductCellDelegate: class {
    func basketProductCellDidTapAmount(cell: BasketProductCell)
}

class BasketProductCell: UITableViewCell {
    static let cellHeight: CGFloat = 72
    static let photoSize: CGSize = CGSizeMake(59, 72)
    static let internalSpacing: CGFloat = 10
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let propertiesLabel = UILabel()
    let priceLabel = PriceLabel()
    let amountButton = UIButton()
    
    weak var delegate: BasketProductCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        photoImageView.layer.masksToBounds = true
        photoImageView.contentMode = .ScaleAspectFill
        
        nameLabel.font = UIFont(fontType: .List)
        nameLabel.numberOfLines = 2
        
        propertiesLabel.font = UIFont(fontType: .List)
        propertiesLabel.textColor = UIColor(named: .DarkGray)
        propertiesLabel.numberOfLines = 2
        
        amountButton.applyDropDownStyle()
        amountButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        amountButton.addTarget(self, action: #selector(BasketProductCell.didTapAmount), forControlEvents: .TouchUpInside)
        
        priceLabel.textAlignment = NSTextAlignment.Right
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(propertiesLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(amountButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with product: BasketProduct) {
        nameLabel.text = product.name
        photoImageView.image = nil
        photoImageView.loadImageFromUrl(product.imageUrl)
        propertiesLabel.text = product.size.name + ", " + product.color.name
        priceLabel.basePrice = product.basePrice
        priceLabel.discountPrice = product.price
        amountButton.setTitle(String(product.amount) + " szt.", forState: .Normal)
    }
    
    func didTapAmount() {
        delegate?.basketProductCellDidTapAmount(self)
    }
    
    private func configureCustomConstraints() {
        photoImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.size.equalTo(BasketProductCell.photoSize)
        }
        
        nameLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(photoImageView.snp_right).offset(BasketProductCell.internalSpacing)
            make.right.lessThanOrEqualTo(amountButton.snp_left).offset(-BasketProductCell.internalSpacing)
        }
        
        propertiesLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(BasketProductCell.internalSpacing)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(amountButton.snp_left).offset(-BasketProductCell.internalSpacing)
        }
        
        priceLabel.snp_makeConstraints { make in
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        amountButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
}

class BasketShippingCell: UITableViewCell {
    let shippingLabel = UILabel()
    let priceLabel = UILabel()
    let separatorView = UIView()
    static let cellHeight: CGFloat = 32
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        shippingLabel.font = UIFont(fontType: .List)
        priceLabel.font = UIFont(fontType: .List)
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(shippingLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        shippingLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        priceLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.left.greaterThanOrEqualTo(shippingLabel.snp_right)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
}