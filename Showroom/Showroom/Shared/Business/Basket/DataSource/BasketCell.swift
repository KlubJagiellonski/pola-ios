import Foundation
import UIKit

class BasketProductCell: UITableViewCell {
    static let cellHeight: CGFloat = 72
    static let photoSize: CGFloat = 72
    static let internalSpacing: CGFloat = 10
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let propertiesLabel = UILabel()
    let priceLabel = UILabel()
    let amountButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        photoImageView.layer.masksToBounds = true
        photoImageView.contentMode = .ScaleAspectFill
        
        nameLabel.font = UIFont(fontType: .List)
        nameLabel.numberOfLines = 2
        
        propertiesLabel.font = UIFont(fontType: .List)
        propertiesLabel.textColor = UIColor(named: .DarkGray)
        propertiesLabel.numberOfLines = 2
        
        priceLabel.font = UIFont(fontType: .List)
        
        amountButton.applyDropDownStyle()
        amountButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        
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
    
    func updateData(item: BasketProduct) {
        nameLabel.text = item.name
        photoImageView.loadImageFromUrl(item.imageUrl!)
        if (item.size != nil && item.color != nil) {
            propertiesLabel.text = item.size! + ", " + item.color!
        } else if (item.size != nil) {
            propertiesLabel.text = item.size
        } else if (item.color != nil) {
            propertiesLabel.text = item.color
        }
        
        priceLabel.text = item.price.stringValue
        amountButton.setTitle(String(item.amount) + " szt.", forState: .Normal)
    }
    
    private func configureCustomConstraints() {
        photoImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalTo(BasketProductCell.photoSize)
            make.height.equalTo(BasketProductCell.photoSize)
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
        
        shippingLabel.font = UIFont(fontType: .List)
        shippingLabel.text = "Wysyłka w 7-10 dni, kurier UPS" // TODO: Use real data
        
        priceLabel.font = UIFont(fontType: .List)
        priceLabel.text = "100,00 zł" // TODO: Use real data
        
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
            make.height.equalTo(1)
            make.width.equalToSuperview().dividedBy(3)
            make.centerX.equalToSuperview()
        }
    }
}