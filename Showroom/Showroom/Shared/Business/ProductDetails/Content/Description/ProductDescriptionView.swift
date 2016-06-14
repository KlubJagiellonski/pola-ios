import Foundation
import UIKit
import RxSwift

extension ProductDetailsColor {
    func toDropDownValue() -> DropDownValue {
        switch type {
        case .Image:
            return .Image(value)
        case .RGB:
            return .Color(UIColor(hex: value))
        }
    }
}

protocol ProductDescriptionViewDelegate: class {
    func descriptionViewDidTapSize(view: ProductDescriptionView)
    func descriptionViewDidTapColor(view: ProductDescriptionView)
    func descriptionViewDidTapSizeChart(view: ProductDescriptionView)
    func descriptionViewDidTapOtherBrandProducts(view: ProductDescriptionView)
    func descriptionViewDidTapAddToBasket(view: ProductDescriptionView)
}

class ProductDescriptionView: UIView, UITableViewDelegate, ProductDescriptionViewInterface {
    private let defaultVerticalPadding: CGFloat = 8
    private let descriptionTableViewTopMargin: CGFloat = 10
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    private let headerView = DescriptionHeaderView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let separatorView = UIView()
    
    private let descriptionDataSource: ProductDescriptionDataSource
    private let disposeBag = DisposeBag()
    private let modelState: ProductPageModelState
    
    weak var delegate: ProductDescriptionViewDelegate?
    
    var contentInset: UIEdgeInsets? {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, contentInset?.bottom ?? 0, 0)
        }
    }
    
    var headerHeight: CGFloat {
        return tableView.frame.minY
    }
    
    var calculatedHeaderHeight: CGFloat {
        return defaultVerticalPadding + headerView.intrinsicContentSize().height + descriptionTableViewTopMargin
    }
    
    init(modelState: ProductPageModelState) {
        self.modelState = modelState
        descriptionDataSource = ProductDescriptionDataSource(tableView: tableView)
        
        super.init(frame: CGRectZero)
        
        modelState.currentColorObservable.subscribeNext(updateCurrentColor).addDisposableTo(disposeBag)
        modelState.currentSizeObservable.subscribeNext(updateCurrentSize).addDisposableTo(disposeBag)
        modelState.buyButtonObservable.subscribeNext(updateBuyButtonEnabledState).addDisposableTo(disposeBag)
        modelState.productDetailsObservable.subscribeNext(updateProductDetails).addDisposableTo(disposeBag)
        updateProduct(modelState.product)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = descriptionDataSource
        tableView.delegate = self
        
        headerView.sizeButton.addTarget(self, action: #selector(ProductDescriptionView.didTapSizeButton), forControlEvents: .TouchUpInside)
        headerView.colorButton.addTarget(self, action: #selector(ProductDescriptionView.didTapColorButton), forControlEvents: .TouchUpInside)
        headerView.buyButton.addTarget(self, action: #selector(ProductDescriptionView.didTapAddToBasketButton), forControlEvents: .TouchUpInside)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        addSubview(blurView)
        addSubview(headerView)
        addSubview(separatorView)
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCurrentColor(currentColor: ProductDetailsColor?) {
        headerView.colorButton.value = currentColor?.toDropDownValue() ?? .Text(nil)
    }
    
    private func updateCurrentSize(currentSize: ProductDetailsSize?) {
        headerView.sizeButton.value = .Text(currentSize?.name)
    }
    
    private func updateBuyButtonEnabledState(enabled: Bool) {
        headerView.buyButton.enabled = enabled
    }
    
    private func updateProduct(product: Product?) {
        guard let p = product else { return }
        headerView.brandNameLabel.text = p.brand
        headerView.nameLabel.text = p.name
        headerView.priceLabel.basePrice = p.basePrice
        if p.basePrice != p.price {
            headerView.priceLabel.discountPrice = p.price
        }
    }
    
    private func updateProductDetails(productDetails: ProductDetails?) {
        guard let p = productDetails else { return }
        
        headerView.brandNameLabel.text = p.brand.name
        headerView.nameLabel.text = p.name
        headerView.priceLabel.basePrice = p.basePrice
        if p.basePrice != p.price {
            headerView.priceLabel.discountPrice = p.price
        }
        headerView.colorButton.enabled = true
        headerView.sizeButton.enabled = true
        headerView.buyButton.enabled = true
        descriptionDataSource.updateModel(p.waitTime, descriptions: p.description)
        
        headerView.priceLabel.invalidateIntrinsicContentSize()
        headerView.invalidateIntrinsicContentSize()
    }
    
    func didTapSizeButton(button: UIButton) {
        delegate?.descriptionViewDidTapSize(self)
    }
    
    func didTapColorButton(button: UIButton) {
        delegate?.descriptionViewDidTapColor(self)
    }
    
    func didTapAddToBasketButton(button: UIButton) {
        delegate?.descriptionViewDidTapAddToBasket(self)
    }
    
    private func configureCustomConstraints() {
        blurView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(defaultVerticalPadding)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        separatorView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(headerView.snp_bottom).offset(descriptionTableViewTopMargin)
            make.height.equalTo(1)
        }
        
        tableView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(separatorView.snp_bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return descriptionDataSource.heightForRow(atIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let descriptionRow = ProductDescriptionRow(rawValue: indexPath.row)
        guard let row = descriptionRow else { return }
        switch row {
        case .BrandProducts:
            delegate?.descriptionViewDidTapOtherBrandProducts(self)
        case .SizeChart:
            delegate?.descriptionViewDidTapSizeChart(self)
        default: break
        }
    }
}

class DescriptionHeaderView: UIView {
    private let defaultVerticalPadding: CGFloat = 8
    private let horizontalItemPadding: CGFloat = 5
    private let buttonsToNameInfoVerticalPadding: CGFloat = 13
    private let dropDownButtonWidth: CGFloat = 60
    
    let brandAndPriceContainerView = UIView()
    let brandNameLabel = UILabel()
    let priceLabel = PriceLabel()
    let nameInfoContainerView = UIView()
    let nameLabel = UILabel()
    let infoImageView = UIImageView(image: UIImage(asset: .Ic_info))
    let buttonsContainerView = TouchConsumingView()
    let sizeButton = DropDownButton()
    let colorButton = DropDownButton()
    let buyButton = UIButton()
    
    init() {
        super.init(frame: CGRectZero)
        
        brandNameLabel.font = UIFont(fontType: .Bold)
        brandNameLabel.numberOfLines = 2
        brandNameLabel.textColor = UIColor(named: .Black)
        
        priceLabel.normalPriceLabel.font = UIFont(fontType: .PriceNormal)
        priceLabel.strikedPriceLabel.font = UIFont(fontType: .FormNormal)
        priceLabel.textAlignment = .Right
        
        nameLabel.font = UIFont(fontType: .Normal)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = UIColor(named: .Black)
        
        sizeButton.enabled = false
        sizeButton.value = .Text("")
        colorButton.enabled = false
        colorButton.value = .Text("")
        
        buyButton.applyBlueStyle()
        buyButton.setTitle(tr(.ProductDetailsToBasket), forState: .Normal)
        buyButton.enabled = false
        
        brandAndPriceContainerView.addSubview(brandNameLabel)
        brandAndPriceContainerView.addSubview(priceLabel)
        
        nameInfoContainerView.addSubview(nameLabel)
        nameInfoContainerView.addSubview(infoImageView)
        
        buttonsContainerView.addSubview(sizeButton)
        buttonsContainerView.addSubview(colorButton)
        buttonsContainerView.addSubview(buyButton)
        
        addSubview(brandAndPriceContainerView)
        addSubview(nameInfoContainerView)
        addSubview(buttonsContainerView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        //brand and price container
        brandAndPriceContainerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        brandNameLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        priceLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        priceLabel.snp_makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.equalTo(brandNameLabel.snp_trailing).offset(horizontalItemPadding)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //name and info container
        
        nameInfoContainerView.snp_makeConstraints { make in
            make.top.equalTo(brandAndPriceContainerView.snp_bottom).offset(defaultVerticalPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        infoImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(nameLabel.snp_trailing).offset(horizontalItemPadding)
            make.width.equalTo(infoImageView.image!.size.width)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        //buttons container
        
        buttonsContainerView.snp_makeConstraints { make in
            make.top.equalTo(nameInfoContainerView.snp_bottom).offset(buttonsToNameInfoVerticalPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        colorButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(dropDownButtonWidth)
        }
        
        sizeButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(colorButton.snp_trailing).offset(horizontalItemPadding)
            make.bottom.equalToSuperview()
            make.width.equalTo(dropDownButtonWidth)
        }
        
        buyButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        buyButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(sizeButton.snp_trailing).offset(horizontalItemPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultButtonHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let priceWidth = priceLabel.intrinsicContentSize().width
        let brandNameAvailableWidth = bounds.width - priceWidth - horizontalItemPadding
        let brandNameHeight = brandNameLabel.text?.heightWithConstrainedWidth(brandNameAvailableWidth, font: brandNameLabel.font) ?? 0
        let brandAndPriceHeight = max(brandNameHeight, priceLabel.intrinsicContentSize().height)
        
        let infoWidth = infoImageView.intrinsicContentSize().width
        let nameAvailableWidth = bounds.width - infoWidth - horizontalItemPadding
        let nameHeight = nameLabel.text?.heightWithConstrainedWidth(nameAvailableWidth, font: nameLabel.font) ?? 0
        let nameAndInfoHeight = max(nameHeight, infoImageView.intrinsicContentSize().height)
        
        let height = defaultVerticalPadding + brandAndPriceHeight + defaultVerticalPadding + nameAndInfoHeight + buttonsToNameInfoVerticalPadding + Dimensions.defaultButtonHeight
        
        return CGSizeMake(UIViewNoIntrinsicMetric, height)
    }
}

class TouchConsumingView: UIView, TouchHandlingDelegate {
    func shouldConsumeTouch(touch: UITouch) -> Bool {
        return true
    }
}