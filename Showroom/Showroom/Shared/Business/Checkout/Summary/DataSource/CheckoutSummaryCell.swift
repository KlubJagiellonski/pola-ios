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
        
        descriptionLabel.font = UIFont(fontType: .CheckoutSummary)
        descriptionLabel.valueLabel.textColor = UIColor(named: .OldLavender)
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
        descriptionLabel.title = product.name
        descriptionLabel.value = tr(.CheckoutSummaryProductDescription(String(product.amount), product.size.name, product.color.name))
        priceLabel.basePrice = product.price
    }
    
    func updateData(with brand: BasketBrand, carrier deliveryCarrier: DeliveryCarrier) {
        let deliveryWaitTime = brand.waitTime
        let deliveryTimeDescription = (deliveryWaitTime == 0 ? tr(.CommonDeliveryInfoSingle(String(deliveryWaitTime))) : tr(.CommonDeliveryInfoMulti(String(deliveryWaitTime))))
        
        descriptionLabel.title =  String(format: "%@, %@", deliveryTimeDescription, deliveryCarrier.name)
        descriptionLabel.value = nil
        priceLabel.basePrice = brand.shippingPrice!
    }
}

/// Header cell of a brand.
class CheckoutSummaryBrandCell: UITableViewCell {
    static let cellHeight: CGFloat = Dimensions.defaultCellHeight
    
    let headerLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        headerLabel.font = UIFont(fontType: .FormBold)
        
        contentView.addSubview(headerLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        headerLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview()
        }
    }
}

protocol CheckoutSummaryCommentCellDelegate: class {
    func checkoutSummaryCommentCellDidTapAdd(cell: CheckoutSummaryCommentCell)
    func checkoutSummaryCommentCellDidTapEdit(cell: CheckoutSummaryCommentCell)
    func checkoutSummaryCommentCellDidTapDelete(cell: CheckoutSummaryCommentCell)
}

/// This cell shows options to add/edit/remove user comment to brand.
class CheckoutSummaryCommentCell: UITableViewCell {    
    private let commentLabel = TitleValueLabel()
    private let addButton = UIButton()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    private let buttonsStackView = UIStackView()
    let separatorView = UIView()
    
    weak var delegate: CheckoutSummaryCommentCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        commentLabel.font = UIFont(fontType: .CheckoutSummary)
        commentLabel.valueLabel.numberOfLines = 3
        commentLabel.valueLabel.textColor = UIColor(named: .OldLavender)
        commentLabel.title = tr(.CheckoutSummaryCommentTitle)
        commentLabel.value = nil
        commentLabel.hidden = true
        
        addButton.applyPlainStyle()
        addButton.setTitle(tr(.CheckoutSummaryAddComment), forState: .Normal)
        addButton.hidden = false
        addButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapAddComment), forControlEvents: .TouchUpInside)
        
        editButton.applyPlainStyle()
        editButton.setTitle(tr(.CheckoutSummaryEditComment), forState: .Normal)
        editButton.hidden = true
        editButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapEditComment), forControlEvents: .TouchUpInside)
        
        deleteButton.applyPlainStyle()
        deleteButton.setTitle(tr(.CheckoutSummaryDeleteComment), forState: .Normal)
        deleteButton.hidden = true
        deleteButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapDeleteComment), forControlEvents: .TouchUpInside)
        
        buttonsStackView.distribution = .EqualSpacing
        buttonsStackView.spacing = Dimensions.defaultCellHeight
        buttonsStackView.addArrangedSubview(addButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        buttonsStackView.addArrangedSubview(editButton)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(buttonsStackView)
        contentView.addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        commentLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        buttonsStackView.snp_makeConstraints { make in
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(4)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
    
    func didTapAddComment() {
        delegate?.checkoutSummaryCommentCellDidTapAdd(self)
    }
    
    func didTapEditComment() {
        delegate?.checkoutSummaryCommentCellDidTapEdit(self)
    }
    
    func didTapDeleteComment() {
        delegate?.checkoutSummaryCommentCellDidTapDelete(self)
    }
    
    func updateData(withComment comment: String?) {
        guard let comment = comment else {
            commentLabel.hidden = true
            addButton.hidden = false
            deleteButton.hidden = true
            editButton.hidden = true
            return
        }
        
        commentLabel.value = comment
        commentLabel.hidden = false
        addButton.hidden = true
        deleteButton.hidden = false
        editButton.hidden = false
    }
    
    class func getHeight(forWidth width: CGFloat, comment: String?) -> CGFloat {
        guard let comment = comment else {
            return 24
        }
        
        let commentHeight = comment.heightWithConstrainedWidth(width - Dimensions.defaultMargin * 2, font: UIFont(fontType: .CheckoutSummary), numberOfLines: 3)
        return commentHeight + 44 // + 44 for buttons height and margins
    }
}

/// Helper view for showing prices with titles.
class CheckoutSummaryPriceView: UIView {
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
        
        titleLabel.text = title
        
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

/// Temporary view representing PayU component that will be added later.
class PayUButton: UIView {
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .DarkGray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 38)
    }
}

/// Shows pricing and delivery info on the bottom. It has two possible heights
/// depending on discount presence.
class CheckoutSummaryPaymentCell: UITableViewCell {
    private static let cellHeightMax: CGFloat = 240
    private static let discountCellHeight: CGFloat = 28
    
    private var discountHeightConstraint: Constraint?
    
    private let discountLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryDiscountCode("")))
    private let totalPriceLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryTotalPrice))
    private let methodLabel = UILabel()
    private let payuRadio = RadioButton(title: tr(.CheckoutSummaryPayU))
    private let payuButton = PayUButton()
    private let cashRadio = RadioButton(title: tr(.CheckoutSummaryCash))
    private let separatorView1 = UIView()
    private let separatorView2 = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        separatorView1.backgroundColor = UIColor(named: .Blue)
        separatorView2.backgroundColor = UIColor(named: .Blue)
        
        discountLabel.font = UIFont(fontType: .CheckoutSummary)
        
        totalPriceLabel.font = UIFont(fontType: .PriceBold)
        
        methodLabel.text = tr(.CheckoutSummaryPaymentMethod)
        methodLabel.font = UIFont(fontType: .FormBold)
        
        payuRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangePayuValue), forControlEvents: .ValueChanged)
        payuRadio.selected = true
        cashRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangeCashValue), forControlEvents: .ValueChanged)
        
        contentView.addSubview(discountLabel)
        contentView.addSubview(separatorView1)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(separatorView2)
        contentView.addSubview(methodLabel)
        contentView.addSubview(payuRadio)
        contentView.addSubview(payuButton)
        contentView.addSubview(cashRadio)
        
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
        
        payuRadio.snp_makeConstraints { make in
            make.top.equalTo(methodLabel.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        payuButton.snp_makeConstraints { make in
            make.top.equalTo(payuRadio.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        cashRadio.snp_makeConstraints { make in
            make.top.equalTo(payuButton.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    func updateData(withTotalPrice totalPrice: Money, totalBasePrice: Money, discountCode: String?) {
        totalPriceLabel.priceLabel.text = totalPrice.stringValue
        if discountCode == nil {
            discountLabel.hidden = true
            discountHeightConstraint?.updateOffset(0)
        } else {
            discountLabel.titleLabel.text = tr(.CheckoutSummaryDiscountCode(discountCode ?? ""))
            discountLabel.priceLabel.text = (totalPrice - totalBasePrice).stringValue
            discountLabel.hidden = false
            discountHeightConstraint?.updateOffset(CheckoutSummaryPaymentCell.discountCellHeight)
        }
    }
    
    class func getHeight(forBasePrice basePrice: Money, discountedPrice price: Money) -> CGFloat {
        if basePrice == price {
            return CheckoutSummaryPaymentCell.cellHeightMax - CheckoutSummaryPaymentCell.discountCellHeight
        } else {
            return CheckoutSummaryPaymentCell.cellHeightMax
        }
    }
    
    // TODO: Move to delegate
    func didChangePayuValue() {
        payuRadio.selected = true
        cashRadio.selected = false
    }
    
    // TODO: Move to delegate
    func didChangeCashValue() {
        payuRadio.selected = false
        cashRadio.selected = true
    }
}

class CheckoutSummaryBuyCell: UITableViewCell {
    static let cellHeight: CGFloat = Dimensions.bigButtonHeight
    
    let buyButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        buyButton.setTitle(tr(.CheckoutSummaryBuy), forState: .Normal)
        buyButton.applyBlueStyle()
        contentView.addSubview(buyButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        buyButton.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}