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
        priceLabel.basePrice = product.sumPrice!
    }
    
    func updateData(with brand: BasketBrand, carrier deliveryCarrier: DeliveryCarrier) {
        let deliveryWaitTime = brand.waitTime!
        let deliveryTimeDescription = (deliveryWaitTime == 1 ? tr(.CommonDeliveryInfoSingle(String(deliveryWaitTime))) : tr(.CommonDeliveryInfoMulti(String(deliveryWaitTime))))
        
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

class PayUContainerView: UIControl {
    var payUButton: UIView? {
        didSet {
            updateButtonState()
            if let button = payUButton {
                addSubview(button)
                button.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        layer.borderColor = UIColor(hex: "E4E5E3")?.CGColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 50)
    }
    
    override var enabled: Bool {
        didSet { updateButtonState() }
    }
    
    private func updateButtonState() {
        payUButton?.alpha = enabled ? 1.0 : 0.3
        payUButton?.userInteractionEnabled = enabled
    }
}

enum CheckoutSummaryPaymentType {
    case Cash
    case PayU
}

protocol CheckoutSummaryPaymentCellDelegate: class {
    func checkoutSummary(cell: CheckoutSummaryPaymentCell, didChangePaymentType type: CheckoutSummaryPaymentType)
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
    private let payuRadio = RadioButton()
    private let payuContainerView = PayUContainerView()
    private let cashRadio = RadioButton()
    private let separatorView1 = UIView()
    private let separatorView2 = UIView()
    
    var payUButton: UIView? {
        set { payuContainerView.payUButton = newValue }
        get { return payuContainerView.payUButton }
    }
    weak var delegate: CheckoutSummaryPaymentCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        separatorView1.backgroundColor = UIColor(named: .Blue)
        separatorView2.backgroundColor = UIColor(named: .Blue)
        
        discountLabel.font = UIFont(fontType: .CheckoutSummary)
        
        totalPriceLabel.font = UIFont(fontType: .PriceBold)
        
        methodLabel.text = tr(.CheckoutSummaryPaymentMethod)
        methodLabel.font = UIFont(fontType: .FormBold)
        
        payuRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangeToPayuValue), forControlEvents: .ValueChanged)
        cashRadio.addTarget(self, action: #selector(CheckoutSummaryPaymentCell.didChangeToCashValue), forControlEvents: .ValueChanged)
        
        contentView.addSubview(discountLabel)
        contentView.addSubview(separatorView1)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(separatorView2)
        contentView.addSubview(methodLabel)
        contentView.addSubview(payuRadio)
        contentView.addSubview(payuContainerView)
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
        
        payuContainerView.snp_makeConstraints { make in
            make.top.equalTo(payuRadio.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        cashRadio.snp_makeConstraints { make in
            make.top.equalTo(payuContainerView.snp_bottom)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    func updateData(withTotalPrice totalPrice: Money, discount: Money?, discountCode: String?, payments: [Payment]?) {
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
        if let payments = payments {
            let payUPayment = payments.find { $0.id == PaymentType.PayU }
            let cashPayment = payments.find { $0.id == PaymentType.Cash }
            let gratisPayment = payments.find { $0.id == PaymentType.Gratis }
            
            payuRadio.title = payUPayment?.name ?? ""
            cashRadio.title = cashPayment?.name ?? ""
            
            if gratisPayment?.available == true {
                methodLabel.textColor = UIColor(named: ColorName.DarkGray)
                payuRadio.selected = false
                payuRadio.enabled = false
                payuContainerView.enabled = false
                cashRadio.enabled = false
                cashRadio.selected = false
            } else {
                methodLabel.textColor = UIColor(named: ColorName.Black)
                payuRadio.enabled = payUPayment?.available ?? false
                payuRadio.selected = payUPayment?.isDefault ?? false
                payuContainerView.enabled = payuRadio.selected
                cashRadio.enabled = cashPayment?.available ?? false
                cashRadio.selected = cashPayment?.isDefault ?? false
            }
        } else {
            payuRadio.selected = false
            payuRadio.enabled = false
            payuContainerView.enabled = false
            cashRadio.enabled = false
            cashRadio.selected = false
        }
    }
    
    class func getHeight(withDiscount hasDiscount: Bool) -> CGFloat {
        if hasDiscount {
            return CheckoutSummaryPaymentCell.cellHeightMax
        } else {
            return CheckoutSummaryPaymentCell.cellHeightMax - CheckoutSummaryPaymentCell.discountCellHeight
        }
    }
    
    func didChangeToPayuValue() {
        payuRadio.selected = true
        payuContainerView.enabled = true
        cashRadio.selected = false
        delegate?.checkoutSummary(self, didChangePaymentType: .PayU)
    }
    
    func didChangeToCashValue() {
        payuRadio.selected = false
        payuContainerView.enabled = false
        cashRadio.selected = true
        delegate?.checkoutSummary(self, didChangePaymentType: .Cash)
    }
}