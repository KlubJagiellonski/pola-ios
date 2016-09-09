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
    let headerHeight: CGFloat = 158
    
    private let headerView = DescriptionHeaderView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let separatorView = UIView()
    
    private let descriptionDataSource: ProductDescriptionDataSource
    private let disposeBag = DisposeBag()
    
    weak var delegate: ProductDescriptionViewDelegate?
    
    var contentInset: UIEdgeInsets? {
        didSet {
            let bottomInset = contentInset?.bottom ?? 0
            tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInset + 12, 0)
        }
    }
    
    var touchRequiredView: UIView {
        return tableView
    }
    
    init(modelState: ProductPageModelState) {
        descriptionDataSource = ProductDescriptionDataSource(tableView: tableView)
        
        super.init(frame: CGRectZero)
        
        modelState.currentColorObservable.subscribeNext { [weak self] currentColor in
            self?.updateCurrentColor(currentColor)
            }.addDisposableTo(disposeBag)
        modelState.currentSizeObservable.subscribeNext { [weak self] currentSize in
            self?.updateCurrentSize(currentSize)
            }.addDisposableTo(disposeBag)
        modelState.productDetailsObservable.subscribeNext { [weak self] productDetails in
            self?.updateProductDetails(productDetails)
            }.addDisposableTo(disposeBag)
        updateProduct(modelState.product)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = descriptionDataSource
        tableView.delegate = self
        
        headerView.sizeButton.addTarget(self, action: #selector(ProductDescriptionView.didTapSizeButton), forControlEvents: .TouchUpInside)
        headerView.colorButton.addTarget(self, action: #selector(ProductDescriptionView.didTapColorButton), forControlEvents: .TouchUpInside)
        headerView.buyButton.addTarget(self, action: #selector(ProductDescriptionView.didTapAddToBasketButton), forControlEvents: .TouchUpInside)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        addSubview(headerView)
        addSubview(separatorView)
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCurrentColor(currentColor: ProductDetailsColor?) {
        headerView.colorButton.value = currentColor?.toDropDownValue() ?? .Color(nil)
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
        } else {
            headerView.priceLabel.discountPrice = nil
        }
    }
    
    private func updateProductDetails(productDetails: ProductDetails?) {
        guard let p = productDetails else { return }
        
        headerView.brandNameLabel.text = productDetails?.brand.name
        headerView.nameLabel.text = productDetails?.name
        headerView.priceLabel.basePrice = p.basePrice
        if p.basePrice != p.price {
            headerView.priceLabel.discountPrice = p.price
        } else {
            headerView.priceLabel.discountPrice = nil
        }
        
        let productAvailability: ProductAvailability = { _ in
            switch (p.available, p.onVacationDate) {
            case (true, let onVacationDate):
                let oneSize = p.sizes.count == 1    // or <= 1 ?
                let oneColor = p.colors.count == 1
                
                if let date = onVacationDate {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "dd.MM"
                    let dateString = formatter.stringFromDate(date)
                    
                    return .AvailableAtDate(dateString: dateString, oneSize: oneSize, oneColor: oneColor)
                } else {
                    return .Available(oneSize: oneSize, oneColor: oneColor)
                }
            case (false, _):
                return .SoldOut
            }
        }()
        headerView.update(toProductAvailability: productAvailability)
        
        descriptionDataSource.updateModel(p.waitTime, descriptions: p.description, brandName: p.brand.name, sizeChartVisible: p.containSizesMeasurements)
        
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
        headerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(headerHeight)
        }
        
        separatorView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(headerView.snp_bottom)
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
        let descriptionRow = descriptionDataSource.row(forIndexPath: indexPath)
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

enum ProductAvailability {
    case Available(oneSize: Bool, oneColor: Bool)
    case Unknown
    case AvailableAtDate(dateString: String, oneSize: Bool, oneColor: Bool)
    case SoldOut
}

class DescriptionHeaderView: UIView {
    private let defaultVerticalPadding: CGFloat = 8
    private let horizontalItemPadding: CGFloat = 5
    private let buttonsToNameInfoVerticalPadding: CGFloat = 13
    private let smallDropDownButtonWidth: CGFloat = 54
    private let largeDropDownButtonWidth: CGFloat = 81
    
    let brandAndPriceContainerView = UIView()
    let brandNameLabel = UILabel()
    let priceLabel = PriceLabel()
    let nameInfoContainerView = UIView()
    let nameLabel = UILabel()
    let infoImageView = UIImageView(image: UIImage(asset: .Ic_info))
    let buttonsContainerView = TouchConsumingView()
    let sizeButton = DropDownButton()
    let colorButton = DropDownButton(value: .Color(nil))
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
        colorButton.enabled = false
        
        buyButton.applyBlueStyle()
        update(toProductAvailability: .Unknown)
        
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
    
    func update(toProductAvailability newProductAvailability: ProductAvailability) {
        switch newProductAvailability {
            
        case .Available(let oneSize, let oneColor):
            buyButton.enabled = true
            buyButton.setTitle(tr(.ProductDetailsToBasket), forState: .Normal)
            colorButton.enabled = !oneColor
            sizeButton.enabled = !oneSize
            
        case .AvailableAtDate(let dateString, let oneSize, let oneColor):
            buyButton.enabled = false
            buyButton.setTitle(tr(.ProductDetailsAvailableAtDate(dateString)), forState: .Normal)
            colorButton.enabled = !oneColor
            sizeButton.enabled = !oneSize
            
        case .SoldOut:
            buyButton.enabled = false
            buyButton.setTitle(tr(.ProductDetailsSoldOut), forState: .Normal)
            colorButton.value = .Color(nil)
            colorButton.enabled = false
            sizeButton.value = .Text(nil)
            sizeButton.enabled = false
            
        case .Unknown:
            buyButton.enabled = false
            buyButton.setTitle(tr(.ProductDetailsToBasket), forState: .Normal)
            colorButton.value = .Color(nil)
            colorButton.enabled = false
            sizeButton.enabled = false
        }
    }
    
    func configureCustomConstraints() {
        //brand and price container
        brandAndPriceContainerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        brandNameLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        priceLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        priceLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(brandNameLabel.snp_trailing).offset(horizontalItemPadding)
            make.trailing.equalToSuperview()
        }
        
        //name and info container
        
        nameInfoContainerView.snp_makeConstraints { make in
            make.top.equalTo(brandAndPriceContainerView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        nameLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        infoImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(nameLabel.snp_trailing).offset(horizontalItemPadding)
            make.width.equalTo(infoImageView.image!.size.width)
        }
        
        //buttons container
        
        buttonsContainerView.snp_makeConstraints { make in
            make.top.equalTo(nameInfoContainerView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        colorButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(smallDropDownButtonWidth)
            make.height.equalTo(Dimensions.defaultButtonHeight)
        }
        
        sizeButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(colorButton.snp_trailing).offset(horizontalItemPadding)
            make.width.equalTo(largeDropDownButtonWidth)
            make.height.equalTo(Dimensions.defaultButtonHeight)
        }
        
        buyButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        buyButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(sizeButton.snp_trailing).offset(horizontalItemPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultButtonHeight)
        }
    }
}

class TouchConsumingView: UIView, TouchHandlingDelegate {
    func shouldConsumeTouch(touch: UITouch) -> Bool {
        return true
    }
}