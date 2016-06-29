import UIKit

/// Represetns cell view for two types of cells: product item and delivery info.
/// Both have a fixed height.
class CheckoutSummaryCell: UITableViewCell {
    static let productCellHeight: CGFloat = 48
    static let deliveryCellHeight: CGFloat = 26
    
    private let descriptionLabel = TitleValueLabel()
    private let priceLabel = PriceLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        descriptionLabel.titleLabel.numberOfLines = 2
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
            make.top.equalToSuperview()
        }
    }
    
    func updateData(with product: BasketProduct) {
        descriptionLabel.title = product.name
        descriptionLabel.value = tr(.CheckoutSummaryProductDescription(String(product.amount), product.size.name, product.color.name))
        priceLabel.basePrice = product.price
    }
    
    func updateData(with brand: BasketBrand, delivery: DeliveryType) {
        let deliveryWaitTime = brand.waitTime
        let deliveryTimeDescription = (deliveryWaitTime == 0 ? tr(.CommonDeliveryInfoSingle(String(deliveryWaitTime))) : tr(.CommonDeliveryInfoMulti(String(deliveryWaitTime))))
        
        var deliveryName: String
        switch delivery {
        case .RUCH:
            deliveryName = tr(.CommonDeliveryRUCH)
        case .UPS:
            deliveryName = tr(.CommonDeliveryUPS)
        }
        
        descriptionLabel.title =  String(format: "%@, %@", deliveryTimeDescription, deliveryName)
        descriptionLabel.value = nil
        priceLabel.basePrice = brand.shippingPrice
    }
}

/// Header cell of a brand.
class CheckoutSummaryBrandCell: UITableViewCell {
    static let cellHeight: CGFloat = Dimensions.defaultCellHeight
    
    let headerLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        headerLabel.font = UIFont(fontType: .FormNormal)
        
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
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(buttonsStackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        commentLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.defaultMargin)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        buttonsStackView.snp_makeConstraints { make in
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
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
            return Dimensions.defaultCellHeight
        }
        
        let commentHeight = comment.heightWithConstrainedWidth(width - Dimensions.defaultMargin * 2, font: UIFont(fontType: .CheckoutSummary), numberOfLines: 3)
        return commentHeight + 70 // +70 for buttons height and margins
    }
}

/// Helper view for showing prices with titles. Can be used without price as 
/// a simple label with proper size.
class CheckoutSummaryPriceView: UIView {
    static let cellHeight: CGFloat = Dimensions.defaultCellHeight
    
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    init(title: String = "", price: Money? = nil) {
        super.init(frame: CGRectZero)
        
        titleLabel.font = UIFont(fontType: .FormBold)
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        
        priceLabel.font = UIFont(fontType: .FormNormal)
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
            make.right.equalTo(priceLabel.snp_left)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        priceLabel.snp_makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalTo(133) // From design, enough for five-digit price, like 10000,00 zł. No need to complicate it with other calculation.
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Dimensions.defaultCellHeight)
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
    private static let cellHeightMax: CGFloat = 288
    
    private let discountLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryDiscount))
    private let totalPriceLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryTotalPrice))
    private let methodLabel = CheckoutSummaryPriceView(title: tr(.CheckoutSummaryPaymentMethod))
    private let payuRadio = RadioButton(title: tr(.CheckoutSummaryPayU))
    private let payuButton = PayUButton()
    private let cashRadio = RadioButton(title: tr(.CheckoutSummaryCash))
    
    private let stackView = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .Fill
        
        totalPriceLabel.priceLabel.font = UIFont(fontType: .PriceNormal)
        
        payuRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangePayuValue), forControlEvents: .ValueChanged)
        payuRadio.selected = true
        cashRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangeCashValue), forControlEvents: .ValueChanged)
        
        stackView.addArrangedSubview(discountLabel)
        stackView.addArrangedSubview(totalPriceLabel)
        stackView.addArrangedSubview(methodLabel)
        stackView.addArrangedSubview(payuRadio)
        stackView.addArrangedSubview(payuButton)
        stackView.addArrangedSubview(cashRadio)
        
        contentView.addSubview(stackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        payuButton.snp_makeConstraints { make in
            make.height.equalTo(payuButton.intrinsicContentSize().height) // For some reason intrinsic size is not enough
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Dimensions.defaultMargin, bottom: Dimensions.defaultMargin, right: Dimensions.defaultMargin))
        }
    }
    
    func updateData(withTotalPrice totalPrice: Money, totalBasePrice: Money) {
        totalPriceLabel.priceLabel.text = totalPrice.stringValue
        if totalPrice == totalBasePrice {
            discountLabel.hidden = true
        } else {
            discountLabel.priceLabel.text = (totalPrice - totalBasePrice).stringValue
            discountLabel.hidden = false
        }
    }
    
    class func getHeight(forBasePrice basePrice: Money, discountedPrice price: Money) -> CGFloat {
        if basePrice == price {
            return CheckoutSummaryPaymentCell.cellHeightMax - Dimensions.defaultCellHeight
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
    static let cellHeight: CGFloat = 52
    
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