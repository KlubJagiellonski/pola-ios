import UIKit
import SnapKit

/// Represetns cell view for two types of cells: product item and delivery info.
/// Both have a fixed height.
class CheckoutSummaryCell: UITableViewCell {
    /// Product cell consists of two lines of text: title and properties.
    static let productCellHeight: CGFloat = 36
    
    /// Delivery info and discount cell are only one line of text with price.
    static let deliveryCellHeight: CGFloat = 20
    
    private let descriptionLabel = TitleValueLabel()
    private let priceLabel = PriceLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        descriptionLabel.backgroundColor = UIColor(named: .White)
        descriptionLabel.font = UIFont(fontType: .CheckoutSummary)
        descriptionLabel.valueLabel.textColor = UIColor(named: .OldLavender)
        
        priceLabel.backgroundColor = UIColor(named: .White)
        priceLabel.normalPriceLabel.font = descriptionLabel.font
        priceLabel.textAlignment = NSTextAlignment.Right
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        descriptionLabel.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview()
        }
        priceLabel.snp_makeConstraints { make in
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.left.equalTo(descriptionLabel.snp_right)
            make.top.equalToSuperview().offset(1)
        }
    }
    
    func updateData(with product: BasketProduct) {
        logInfo("Update data with product: \(product)")
        descriptionLabel.title = product.name
        descriptionLabel.value = tr(.CheckoutSummaryProductDescription(String(product.amount), product.size.name, product.color.name))
        priceLabel.basePrice = product.sumPrice!
    }
    
    func updateData(with brand: BasketBrand, carrier deliveryCarrier: DeliveryCarrier) {
        logInfo("Update data with brand: \(brand), delivery carrier: \(deliveryCarrier)")
        let deliveryWaitTime = brand.waitTime!
        let deliveryTimeDescription = (deliveryWaitTime == 1 ? tr(.CommonDeliveryInfoSingle(String(deliveryWaitTime))) : tr(.CommonDeliveryInfoMulti(String(deliveryWaitTime))))
        
        descriptionLabel.title =  String(format: "%@, %@", deliveryTimeDescription, deliveryCarrier.name)
        descriptionLabel.value = nil
        priceLabel.basePrice = brand.shippingPrice!
    }
}