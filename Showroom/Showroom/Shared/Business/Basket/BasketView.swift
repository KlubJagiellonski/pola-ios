import Foundation
import UIKit
import SnapKit

protocol BasketViewDelegate: class {
    func basketViewDidDeleteProduct(product: BasketProduct)
}

class BasketView: UIView, UITableViewDelegate {
    private let checkoutView = BasketCheckoutView()
    private let dataSource: BasketDataSource;
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    weak var delegate: BasketViewDelegate?
    
    init() {
        dataSource = BasketDataSource(tableView: tableView)
        super.init(frame: CGRectZero)
        
        dataSource.basketView = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        
        checkoutView.layer.shadowColor = UIColor.blackColor().CGColor
        checkoutView.layer.shadowOpacity = 0.5
        checkoutView.layer.shadowRadius = 3;
        checkoutView.layer.shadowOffset = CGSizeMake(0, 2)
        
        addSubview(tableView)
        addSubview(checkoutView)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasketView.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
    
    func updateData(withBasket basket: Basket) {
        dataSource.updateData(basket.productsByBrands)
        checkoutView.updateData(withBasket: basket)
    }
    
    func configureCustomConstraints() {
        checkoutView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimensions.tabViewHeight)
        }
        
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if dataSource.isFooterCell(indexPath) {
            return BasketShippingCell.cellHeight
        } else {
            return BasketProductCell.cellHeight + Dimensions.defaultMargin;
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BasketHeader.headerHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: BasketHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(BasketHeader)) as! BasketHeader
        headerView.headerLabel.text = dataSource.titleForHeaderInSection(section)
        return headerView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.contentInset.bottom = checkoutView.frame.size.height + Dimensions.tabViewHeight
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func dataSourceDidDeleteProduct(product: BasketProduct) {
        delegate?.basketViewDidDeleteProduct(product)
    }
}

class BasketCheckoutView: UIView {
    private let discountInput = UITextField()
    private let shippingButton = UIButton()
    private let checkoutButton = UIButton()
    
    private let discountLabel = TitleValueLabel()
    private let shippingLabel = TitleValueLabel()
    
    private let priceView = UIView()
    private let priceTitleLabel = UILabel()
    private let priceValueLabel = PriceLabel()
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.whiteColor()
        
        discountInput.applyPlainStyle()
        
        shippingButton.setTitle(tr(.BasketShippingChange), forState: .Normal)
        shippingButton.applyPlainStyle()
        
        checkoutButton.setTitle(tr(.BasketCheckoutButton), forState: .Normal)
        checkoutButton.applyBlueStyle()
        
        discountLabel.title = tr(.BasketDiscountCode)
        
        shippingLabel.title = tr(.BasketShipping)
        // TODO: Set shipping info
        
        priceTitleLabel.text = tr(.BasketTotalPrice)
        priceTitleLabel.textColor = UIColor.blackColor()
        priceTitleLabel.font = UIFont(fontType: .List)
        
        priceValueLabel.normalPriceLabel.font = UIFont(fontType: .Normal)
        
        priceView.addSubview(priceTitleLabel)
        priceView.addSubview(priceValueLabel)
        
        addSubview(discountInput)
        addSubview(shippingButton)
        addSubview(checkoutButton)
        addSubview(discountLabel)
        addSubview(shippingLabel)
        addSubview(priceView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Updates the view with new basket data.
     */
    func updateData(withBasket basket: Basket) {
        discountInput.text = basket.discountCode
        priceValueLabel.basePrice = basket.basePrice
        priceValueLabel.discountPrice = basket.price
        
        if (basket.price != nil) {
            discountLabel.value = tr(.BasketDiscount) + ": " + (basket.basePrice - basket.price!).stringValue
        } else {
            discountLabel.value = nil
        }
    }
    
    func configureCustomConstraints() {
        discountInput.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalTo(159)
            make.height.equalTo(Dimensions.defaultInputHeight)
        }
        
        shippingButton.snp_makeConstraints { make in
            make.top.equalTo(discountInput.snp_bottom).offset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultButtonHeight)
        }
        
        checkoutButton.snp_makeConstraints { make in
            make.top.equalTo(shippingButton.snp_bottom).offset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalTo(discountInput.snp_width)
            make.height.equalTo(Dimensions.defaultButtonHeight)
        }
        
        discountLabel.snp_makeConstraints { make in
            make.centerY.equalTo(discountInput)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        shippingLabel.snp_makeConstraints { make in
            make.centerY.equalTo(shippingButton)
            make.left.equalToSuperview().offset(Dimensions.defaultMargin)
            make.right.lessThanOrEqualTo(shippingButton.snp_left)
        }
        
        priceTitleLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        priceValueLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(priceTitleLabel.snp_bottom).offset(-2)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        priceView.snp_makeConstraints { make in
            make.centerY.equalTo(checkoutButton)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
    }
}