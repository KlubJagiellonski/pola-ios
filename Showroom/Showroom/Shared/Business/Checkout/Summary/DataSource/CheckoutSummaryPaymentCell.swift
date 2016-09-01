import UIKit
import SnapKit

/// Shows pricing and delivery info on the bottom. It has two possible heights
/// depending on discount presence.
final class CheckoutSummaryPaymentCell: UITableViewCell {
    private static let cellHeightMax: CGFloat = 120
    private static let discountCellHeight: CGFloat = 28
    
    private var discountHeightConstraint: Constraint?
    
    private let discountLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryDiscountCode("")))
    private let totalPriceLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryTotalPrice))
    private let methodLabel = UILabel()
    private let separatorView1 = UIView()
    private let separatorView2 = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        separatorView1.backgroundColor = UIColor(named: .Blue)
        separatorView2.backgroundColor = UIColor(named: .Blue)
        
        discountLabel.font = UIFont(fontType: .CheckoutSummary)
        
        totalPriceLabel.font = UIFont(fontType: .PriceBold)
        
        methodLabel.backgroundColor = UIColor(named: .White)
        methodLabel.text = tr(.CheckoutSummaryPaymentMethod)
        methodLabel.font = UIFont(fontType: .FormBold)
        
        contentView.addSubview(discountLabel)
        contentView.addSubview(separatorView1)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(separatorView2)
        contentView.addSubview(methodLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        discountLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            discountHeightConstraint = make.height.equalTo(CheckoutSummaryPaymentCell.discountCellHeight).constraint
        }
        
        separatorView1.snp_makeConstraints { make in
            make.top.equalTo(discountLabel.snp_bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        totalPriceLabel.snp_makeConstraints { make in
            make.top.equalTo(separatorView1.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultCellHeight)
        }
        
        separatorView2.snp_makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp_bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        methodLabel.snp_makeConstraints { make in
            make.top.equalTo(separatorView2.snp_bottom).offset(20)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    func updateData(withTotalPrice totalPrice: Money, discount: Money?, discountCode: String?, gratisAvailable: Bool) {
        logInfo("Update data with total price: \(totalPrice), discount: \(discount), discount code: \(discountCode), gratisAvailable: \(gratisAvailable)")
        totalPriceLabel.priceLabel.text = totalPrice.stringValue
        if discountCode == nil || discount == nil {
            discountLabel.hidden = true
            discountHeightConstraint?.updateOffset(0)
        } else {
            discountLabel.titleLabel.text = tr(.CheckoutSummaryDiscountCode(discountCode ?? ""))
            discountLabel.priceLabel.text = discount!.stringValue
            discountLabel.hidden = false
            discountHeightConstraint?.updateOffset(CheckoutSummaryPaymentCell.discountCellHeight)
        }
        methodLabel.textColor = gratisAvailable ? UIColor(named: ColorName.DarkGray) : UIColor(named: ColorName.Black)
    }
    
    class func getHeight(withDiscount hasDiscount: Bool) -> CGFloat {
        if hasDiscount {
            return CheckoutSummaryPaymentCell.cellHeightMax
        } else {
            return CheckoutSummaryPaymentCell.cellHeightMax - CheckoutSummaryPaymentCell.discountCellHeight
        }
    }
}

/// Helper view for showing prices with titles.
private class CheckoutSummaryPriceView: UIView {
    static let cellHeight: CGFloat = Dimensions.defaultCellHeight
    
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    var font: UIFont {
        get {
            return titleLabel.font
        }
        
        set {
            titleLabel.font = newValue
            priceLabel.font = newValue
        }
    }
    
    init(title: String = "", price: Money? = nil) {
        super.init(frame: CGRectZero)
        
        titleLabel.backgroundColor = UIColor(named: .White)
        titleLabel.text = title
        
        priceLabel.backgroundColor = UIColor(named: .White)
        priceLabel.textAlignment = .Right
        if price != nil {
            priceLabel.text = price?.stringValue
        }
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        priceLabel.snp_makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(titleLabel.snp_right)
            make.centerY.equalToSuperview()
        }
    }
}

