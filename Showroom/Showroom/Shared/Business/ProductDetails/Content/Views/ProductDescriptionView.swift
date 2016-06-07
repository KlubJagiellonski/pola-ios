import Foundation
import UIKit

class ProductDescriptionView: UIView {
    private let defaultVerticalPadding: CGFloat = 8
    private let descriptionTableViewTopMargin: CGFloat = 10
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    let headerView = DescriptionHeaderView()
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    init() {
        super.init(frame: CGRectZero)
        
        addSubview(blurView)
        addSubview(headerView)
        addSubview(tableView)
        
        configureCustomConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSimpleModel(product: Product) {
        headerView.brandNameLabel.text = product.brand.name
        headerView.nameLabel.text = product.name
        headerView.priceLabel.basePrice = product.basePrice
        if product.basePrice != product.price {
            headerView.priceLabel.discountPrice = product.price
        }
        
        headerView.invalidateIntrinsicContentSize()
    }
    
    func updateModel(productDetails: ProductDetails, defaultSize: ProductDetailsSize?, defaultColor: ProductDetailsColor?) {
        headerView.brandNameLabel.text = productDetails.brand.name
        headerView.nameLabel.text = productDetails.name
        headerView.priceLabel.basePrice = productDetails.basePrice
        if productDetails.basePrice != productDetails.price {
            headerView.priceLabel.discountPrice = productDetails.price
        }
        headerView.priceLabel.invalidateIntrinsicContentSize()
        if let size = defaultSize {
            headerView.sizeButton.value = .Text(size.name)
        }
        if let color = defaultColor {
            headerView.colorButton.value = color.toDropDownValue()
        }
        
        headerView.invalidateIntrinsicContentSize()
    }
    
    func getHeightForHeader() -> CGFloat {
        return defaultVerticalPadding + headerView.intrinsicContentSize().height + descriptionTableViewTopMargin
    }
    
    func configureCustomConstraints() {
        blurView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(defaultVerticalPadding)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        tableView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(headerView.snp_bottom).offset(descriptionTableViewTopMargin)
            make.bottom.equalToSuperview()
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
    let buttonsContainerView = UIView()
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
        
        buyButton.applyBlueStyle()
        buyButton.setTitle(tr(.ProductDetailsToBasket), forState: .Normal)
        
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
        
        sizeButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(dropDownButtonWidth)
        }
        
        colorButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(sizeButton.snp_trailing).offset(horizontalItemPadding)
            make.bottom.equalToSuperview()
            make.width.equalTo(dropDownButtonWidth)
        }
        
        buyButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        buyButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(colorButton.snp_trailing).offset(horizontalItemPadding)
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