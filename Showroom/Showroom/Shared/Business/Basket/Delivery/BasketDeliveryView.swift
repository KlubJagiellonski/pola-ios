import Foundation
import UIKit

protocol BasketDeliveryViewDelegate: ViewSwitcherDelegate {
    func deliveryViewDidTapOk(view: BasketDeliveryView)
    func deliveryViewDidTapCountry(view: BasketDeliveryView)
    func deliveryViewDidTapUpsOption(view: BasketDeliveryView)
    func deliveryViewDidTapRuchOption(view: BasketDeliveryView)
}

class BasketDeliveryView: ViewSwitcher {
    private let contentView = UIView()
    private let countryTitleLabel = UILabel()
    private let countryDeliveryView = BasketCountryDeliveryView()
    private let deliveryOptionsTitle = UILabel()
    private let upsDeliveryOptionView = BasketDeliveryOptionView()
    private let ruchDeliveryOptionView = BasketDeliveryOptionView()
    private let infoLabel = UILabel()
    private let okButton = UIButton()
    
    weak var delegate: BasketDeliveryViewDelegate? {
        didSet { switcherDelegate = delegate }
    }
    
    init() {
        super.init(successView: contentView, initialState: .Success)
        
        backgroundColor = UIColor(named: .White)
        
        switcherDataSource = self
        
        countryTitleLabel.backgroundColor = UIColor(named: .White)
        countryTitleLabel.font = UIFont(fontType: .FormBold)
        countryTitleLabel.textColor = UIColor(named: .Black)
        countryTitleLabel.text = tr(.BasketDeliveryDeliveryCountry)
        
        countryDeliveryView.addTarget(self, action: #selector(BasketDeliveryView.didTapCountryDelivery(_:)), forControlEvents: .TouchUpInside)
        
        deliveryOptionsTitle.backgroundColor = UIColor(named: .White)
        deliveryOptionsTitle.font = UIFont(fontType: .FormBold)
        deliveryOptionsTitle.textColor = UIColor(named: .Black)
        deliveryOptionsTitle.text = tr(.BasketDeliveryDeliveryOption)
        
        upsDeliveryOptionView.addTarget(self, action: #selector(BasketDeliveryView.didChangeUpsValue(_:)), forControlEvents: .ValueChanged)
        
        ruchDeliveryOptionView.addTarget(self, action: #selector(BasketDeliveryView.didChangeRuchValue(_:)), forControlEvents: .ValueChanged)
        ruchDeliveryOptionView.enabled = false
        
        infoLabel.backgroundColor = UIColor(named: .White)
        infoLabel.font = UIFont(fontType: .Description)
        infoLabel.textColor = UIColor(named: .Black)
        infoLabel.numberOfLines = 0
        infoLabel.text = tr(.BasketDeliveryInfo)
        
        okButton.applyBlueStyle()
        okButton.setTitle(tr(.BasketDeliveryOk), forState: .Normal)
        okButton.addTarget(self, action: #selector(BasketDeliveryView.didTapOkButton(_:)), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(countryTitleLabel)
        contentView.addSubview(countryDeliveryView)
        contentView.addSubview(deliveryOptionsTitle)
        contentView.addSubview(upsDeliveryOptionView)
        contentView.addSubview(ruchDeliveryOptionView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(okButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with basket: Basket?) {
        guard let basket = basket else {
            upsDeliveryOptionView.enabled = false
            ruchDeliveryOptionView.enabled = false
            return
        }
        
        let upsCarrier = basket.deliveryInfo.carriers.find { $0.id.isUps }
        upsDeliveryOptionView.hidden = upsCarrier == nil
        upsDeliveryOptionView.enabled = upsCarrier?.available ?? false
        upsDeliveryOptionView.priceLabel.text = upsCarrier?.deliveryCost?.stringValue
        upsDeliveryOptionView.titleLabel.text = upsCarrier?.name
        
        let ruchCarrier = basket.deliveryInfo.carriers.find { $0.id == DeliveryType.RUCH }
        ruchDeliveryOptionView.hidden = ruchCarrier == nil
        ruchDeliveryOptionView.enabled = ruchCarrier?.available ?? false
        ruchDeliveryOptionView.priceLabel.text = ruchCarrier?.deliveryCost?.stringValue
        ruchDeliveryOptionView.titleLabel.text = ruchCarrier?.name
    }
    
    func updateData(with selectedCountry: DeliveryCountry?) {
        countryDeliveryView.countryLabel.text = selectedCountry?.name
    }
    
    func updateData(with selectedCarrier: DeliveryCarrier?) {
        upsDeliveryOptionView.selected = selectedCarrier?.id.isUps ?? false
        ruchDeliveryOptionView.selected = selectedCarrier?.id == DeliveryType.RUCH
    }
    
    private func configureCustomConstraints() {
        countryTitleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        countryDeliveryView.snp_makeConstraints { make in
            make.top.equalTo(countryTitleLabel.snp_bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        deliveryOptionsTitle.snp_makeConstraints { make in
            make.top.equalTo(countryDeliveryView.snp_bottom).offset(18)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        let optionVerticalMargin = 26
        
        upsDeliveryOptionView.snp_makeConstraints { make in
            make.top.equalTo(deliveryOptionsTitle.snp_bottom).offset(optionVerticalMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        ruchDeliveryOptionView.snp_makeConstraints { make in
            make.top.equalTo(upsDeliveryOptionView.snp_bottom).offset(optionVerticalMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        infoLabel.snp_makeConstraints { make in
            make.top.equalTo(ruchDeliveryOptionView.snp_bottom).offset(optionVerticalMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        okButton.snp_makeConstraints { make in
            make.height.equalTo(46)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
    
    // MARK:- Actions
    
    func didTapOkButton(button: UIButton) {
        delegate?.deliveryViewDidTapOk(self)
    }
    
    func didTapCountryDelivery(countryDeliveryView: BasketCountryDeliveryView) {
        delegate?.deliveryViewDidTapCountry(self)
    }
    
    func didChangeUpsValue(optionView: BasketDeliveryOptionView) {
        delegate?.deliveryViewDidTapUpsOption(self)
    }
    
    func didChangeRuchValue(optionView: BasketDeliveryOptionView) {
        delegate?.deliveryViewDidTapRuchOption(self)
    }
}

extension BasketDeliveryView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}

class BasketCountryDeliveryView: UIControl {
    private static let normalBackgroundColor = UIColor(named: .White)
    private static let highlightedBackgroundColor = UIColor(named: .DarkGray).colorWithAlphaComponent(0.2)
    
    private let topSeparator = UIView()
    private let countryLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    private let bottomSeparator = UIView()
    
    override var highlighted: Bool {
        didSet {
            backgroundColor = highlighted ? BasketCountryDeliveryView.highlightedBackgroundColor : BasketCountryDeliveryView.normalBackgroundColor
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = BasketCountryDeliveryView.normalBackgroundColor
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BasketCountryDeliveryView.didTapView)))
        
        topSeparator.backgroundColor = UIColor(named: .Separator)
        
        countryLabel.font = UIFont(fontType: .FormNormal)
        countryLabel.textColor = UIColor(named: .Black)
        
        bottomSeparator.backgroundColor = UIColor(named: .Separator)
        
        addSubview(topSeparator)
        addSubview(countryLabel)
        addSubview(arrowImageView)
        addSubview(bottomSeparator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView() {
        sendActionsForControlEvents(.TouchUpInside)
    }
    
    private func configureCustomConstraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        countryLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        arrowImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(23)
        }
        
        bottomSeparator.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 45)
    }
}

class BasketDeliveryOptionView: UIControl {
    private static let disabledColor = UIColor(named: .DarkGray)
    private static let enabledColor = UIColor(named: .Black)
    
    private let checkBoxImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    override var enabled: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateViewsState()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BasketDeliveryOptionView.didTapView)))
        
        checkBoxImageView.tintColor = BasketDeliveryOptionView.disabledColor
        
        titleLabel.backgroundColor = UIColor(named: .White)
        titleLabel.font = UIFont(fontType: .FormNormal)
        
        priceLabel.backgroundColor = UIColor(named: .White)
        priceLabel.font = UIFont(fontType: .FormNormal)
        
        updateViewsState()
        
        addSubview(checkBoxImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView() {
        selected = !selected
        sendActionsForControlEvents(.ValueChanged)
    }
    
    private func configureCustomConstraints() {
        let horizontalMargin = 3
        
        checkBoxImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalMargin)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp_trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        priceLabel.snp_makeConstraints { make in
            make.leading.equalTo(titleLabel.snp_trailing).offset(horizontalMargin)
            make.trailing.equalToSuperview().inset(horizontalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateViewsState() {
        titleLabel.textColor = enabled ? BasketDeliveryOptionView.enabledColor : BasketDeliveryOptionView.disabledColor
        priceLabel.textColor = enabled ? BasketDeliveryOptionView.enabledColor : BasketDeliveryOptionView.disabledColor
        
        var image = selected ? UIImage(asset: .Ic_checkbox_on) : UIImage(asset: .Ic_checkbox_off)
        if !enabled {
            image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
        checkBoxImageView.image = image
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, max(checkBoxImageView.intrinsicContentSize().height, titleLabel.intrinsicContentSize().height))
    }
}