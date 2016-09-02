import Foundation
import UIKit
import SnapKit

protocol BasketViewDelegate: ViewSwitcherDelegate {
    func basketViewDidDeleteProduct(product: BasketProduct)
    func basketViewDidTapAmount(of product: BasketProduct)
    func basketViewDidTapShipping(view: BasketView)
    func basketViewDidTapCheckoutButton(view: BasketView)
    func basketViewDidTapStartShoppingButton(view: BasketView)
    func basketView(view: BasketView, didChangeDiscountCode discountCode: String?)
    func basketView(view: BasketView, didSelectProductAtIndexPath indexPath: NSIndexPath)
}

final class BasketView: ViewSwitcher, UITableViewDelegate, ContentInsetHandler {
    private let contentView = UIView()
    private let checkoutView = BasketCheckoutView()
    private let checkoutBottomBackgroundView = UIView()
    private let dataSource: BasketDataSource
    let keyboardHelper = KeyboardHelper()
    private var checkoutBottomConstraint: Constraint?
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    var lastUpdateInfo: BasketUpdateInfo? {
        return dataSource.lastBasketUpdateInfo
    }
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            guard contentInset != oldValue else { return }
            
            tableView.contentInset = UIEdgeInsetsMake(contentInset.top, 0, bounds.height - checkoutView.frame.minY, 0)
            tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    var discountCode: String? {
        set { checkoutView.discountInput.text = newValue }
        get { return checkoutView.discountInput.text }
    }
    
    weak var delegate: BasketViewDelegate? {
        didSet { switcherDelegate = delegate }
    }
    
    init() {
        dataSource = BasketDataSource(tableView: tableView)
        super.init(successView: contentView)
        
        switcherDataSource = self
        
        keyboardHelper.delegate = self
        
        dataSource.basketView = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        
        checkoutView.shippingButton.addTarget(self, action: #selector(BasketView.didTapShippingButton), forControlEvents: .TouchUpInside)
        checkoutView.checkoutButton.addTarget(self, action: #selector(BasketView.didTapCheckoutButton), forControlEvents: .TouchUpInside)
        checkoutView.discountInput.delegate = self
        checkoutView.layer.shadowColor = UIColor.blackColor().CGColor
        checkoutView.layer.shadowOpacity = 0.5
        checkoutView.layer.shadowRadius = 3;
        checkoutView.layer.shadowOffset = CGSizeMake(0, 2)
        
        checkoutBottomBackgroundView.backgroundColor = UIColor(named: .White)
        
        contentView.addSubview(tableView)
        contentView.addSubview(checkoutView)
        contentView.addSubview(checkoutBottomBackgroundView)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasketView.dismissKeyboard))
        //it should be disabled when keyboard is hidden. Enabling it would cause cell selecting not work
        tap.enabled = false
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableViewContentInsets()
    }
    
    func deselectRowsIfNeeded() {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func refreshImagesIfNeeded() {
        dataSource.refreshImagesIfNeeded()
    }
    
    func dismissKeyboard() {
        if checkoutView.discountInput.isFirstResponder() {
            delegate?.basketView(self, didChangeDiscountCode: discountCode)
        }
        endEditing(true)
    }
    
    func updateData(with basket: Basket) {
        dataSource.updateData(with: basket.productsByBrands)
        checkoutView.updateData(withBasket: basket)
    }
    
    func updateData(with country: DeliveryCountry?, and carrier: DeliveryCarrier?) {
        checkoutView.updateData(with: country, and: carrier)
    }
    
    func updateData(withValidated validated: Bool) {
        checkoutView.checkoutButton.enabled = validated
    }
    
    func resetDiscountCodeValue() {
        checkoutView.discountInput.imageState = .Default
        checkoutView.discountInput.text = nil
    }
    
    func moveToPosition(at indexPath: NSIndexPath, animated: Bool) {
        dataSource.moveToPosition(at: indexPath, animated: animated)
    }
    
    func didTapShippingButton(button: UIButton) {
        delegate?.basketViewDidTapShipping(self)
    }
    
    func didTapCheckoutButton(button: UIButton) {
        delegate?.basketViewDidTapCheckoutButton(self)
    }
    
    func didTapStartShoppingButton(button: UIButton) {
        delegate?.basketViewDidTapStartShoppingButton(self)
    }
    
    private func configureCustomConstraints() {
        checkoutView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            checkoutBottomConstraint = make.bottom.equalToSuperview().inset(Dimensions.tabViewHeight).constraint
        }
        
        checkoutBottomBackgroundView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Dimensions.tabViewHeight)
            make.top.equalTo(checkoutView.snp_bottom)
        }
        
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateTableViewContentInsets() {
        tableView.contentInset.bottom = bounds.height - checkoutView.frame.minY
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    // MARK:- UITableViewDelegate
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.basketView(self, didSelectProductAtIndexPath: indexPath)
    }
    
    func dataSourceDidDeleteProduct(product: BasketProduct) {
        delegate?.basketViewDidDeleteProduct(product)
    }
    
    func dataSourceDidTapAmount(of product: BasketProduct) {
        delegate?.basketViewDidTapAmount(of: product)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: nil, handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
        })
        
        // This background image was created to work only with basket cells and
        // Polish language. It has a fixed size that fits the size of the delete
        // button which depends on the cell height and the title length.
        deleteButton.backgroundColor = UIColor(patternImage: UIImage(asset: Asset.Bg_delete_basket))
        
        // New line characters allow to move the title label lower.
        deleteButton.title = "\r\n\r\n" + tr(.BasketDelete)
        
        return [deleteButton]
    }
}

extension BasketView: KeyboardHandler, KeyboardHelperDelegate {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions, visible: Bool) {
        //we want to only enable tap gesture recognizer when keyboard is visible.
        gestureRecognizers?.find { $0 is UITapGestureRecognizer }?.enabled = visible
        
        let bottomMargin = keyboardHelper.retrieveBottomMargin(self, keyboardToFrame: toFrame)
        
        checkoutBottomConstraint?.updateOffset(-max(bottomMargin, Dimensions.tabViewHeight))
        
        self.setNeedsLayout()
        let animations = {
            self.layoutIfNeeded()
        }
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: animations, completion: { [weak self] _ in
            self?.updateTableViewContentInsets()
        })
    }
}

extension BasketView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.basketView(self, didChangeDiscountCode: textField.text)
        return true
    }
}

extension BasketView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = BasketEmptyView(contentInset: tableView.contentInset)
        emptyView.startShoppingButton.addTarget(self, action: #selector(BasketView.didTapStartShoppingButton(_:)), forControlEvents: .TouchUpInside)
        return emptyView
    }
}

final class BasketCheckoutView: UIView {
    private let rightViewSize = CGSizeMake(13, 11)
    private let rightViewRightMargin: CGFloat = 11
    
    private let discountInput = StateTextField()
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
        discountInput.returnKeyType = .Send
        
        shippingButton.setTitle(tr(.BasketShippingChange), forState: .Normal)
        shippingButton.applyPlainStyle()
        
        checkoutButton.setTitle(tr(.BasketCheckoutButton), forState: .Normal)
        checkoutButton.applyBlueStyle()
        
        discountLabel.backgroundColor = UIColor(named: .White)
        discountLabel.title = tr(.BasketDiscountCode)
        
        shippingLabel.title = tr(.BasketShipping)
        
        priceTitleLabel.text = tr(.BasketTotalPrice)
        priceTitleLabel.textColor = UIColor.blackColor()
        priceTitleLabel.font = UIFont(fontType: .List)
        
        priceValueLabel.normalPriceLabel.font = UIFont(fontType: .NormalBold)
        
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
        priceValueLabel.basePrice = basket.basePrice
        if basket.basePrice != basket.price {
            priceValueLabel.discountPrice = basket.price
        } else {
            priceValueLabel.discountPrice = nil
        }
        
        discountLabel.value = basket.discount?.stringValue
        
        if basket.discount != nil {
            discountInput.imageState = .Correct
        } else if basket.discountErrors != nil {
            discountInput.imageState = .Invalid
        } else {
            discountInput.imageState = .Default
        }
    }
    
    func updateData(with country: DeliveryCountry?, and carrier: DeliveryCarrier?) {
        if let country = country, let carrier = carrier {
            shippingLabel.value = country.name + ", " + carrier.name
        } else {
            shippingLabel.value = nil
        }
    }
    
    func configureCustomConstraints() {
        discountInput.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.width.equalTo(168)
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

final class BasketEmptyView: UIView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(asset: .Empty_bag))
    private let startShoppingButton = UIButton()
    
    init(contentInset: UIEdgeInsets) {
        super.init(frame: CGRectZero)
        
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.text = tr(.BasketEmpty)
        titleLabel.textAlignment = .Center
        
        startShoppingButton.setTitle(tr(.BasketStartShopping), forState: .Normal)
        startShoppingButton.applyBlueStyle()
        
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(startShoppingButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
        imageView.snp_makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualTo(startShoppingButton.snp_top).offset(-4) // to make it fit on iphone 4s screen
        }
        
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.statusBarHeight + Dimensions.navigationBarHeight)
            make.bottom.equalTo(imageView.snp_top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        startShoppingButton.snp_makeConstraints { make in
            make.bottom.equalToSuperview().inset(Dimensions.tabViewHeight + Dimensions.defaultMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
}