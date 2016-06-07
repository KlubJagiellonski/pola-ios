import Foundation
import UIKit
import SnapKit

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

class ProductPageView: UIView, UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    private let defaultDescriptionTopMargin: CGFloat = 70
    private let descriptionDragVelocityThreshold: CGFloat = 200
    
    private let imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = VerticalPageControl()
    private let descriptionView = ProductDescriptionView()
    private let buttonStackView = UIStackView()
    private let whishlistButton = UIButton()
    private let shareButton = UIButton()
    
    private let imageDataSource: ProductImageDataSource
    private let descriptionDataSource: ProductDescriptionDataSource
    
    private var descriptionTopConstraint: Constraint?
    
    private var descriptionVisible = false
    
    private var descriptionAndButtonsAlpha: CGFloat = 0 {
        didSet {
            descriptionView.alpha = descriptionAndButtonsAlpha
            buttonStackView.alpha = descriptionAndButtonsAlpha
            pageControl.alpha = descriptionAndButtonsAlpha
        }
    }
    
    var contentInset: UIEdgeInsets?
    
    init() {
        imageDataSource = ProductImageDataSource(collectionView: imageCollectionView)
        descriptionDataSource = ProductDescriptionDataSource(tableView: descriptionView.tableView)
        
        super.init(frame: CGRectZero)
        
        imageCollectionView.backgroundColor = UIColor.clearColor()
        imageCollectionView.dataSource = imageDataSource
        imageCollectionView.delegate = self
        imageCollectionView.pagingEnabled = true
        imageCollectionView.showsVerticalScrollIndicator = false
        let flowLayout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        pageControl.alpha = descriptionAndButtonsAlpha
        pageControl.currentPage = 0
        
        descriptionView.alpha = descriptionAndButtonsAlpha
        descriptionView.tableView.dataSource = descriptionDataSource
        descriptionView.tableView.delegate = self
        descriptionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ProductPageView.didPanOnDescriptionView)))
        descriptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductPageView.didTapOnDescriptionView)))
        
        buttonStackView.alpha = descriptionAndButtonsAlpha
        buttonStackView.axis = .Horizontal
        buttonStackView.spacing = 10
        
        whishlistButton.setImage(UIImage(asset: .Ic_do_ulubionych), forState: .Normal)
        whishlistButton.setImage(UIImage(asset: .Ic_w_ulubionych), forState: .Selected)
        whishlistButton.applyCircleStyle()
        
        shareButton.setImage(UIImage(asset: .Ic_share), forState: .Normal)
        shareButton.applyCircleStyle()
        
        buttonStackView.addArrangedSubview(whishlistButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        addSubview(imageCollectionView)
        addSubview(pageControl)
        addSubview(descriptionView)
        addSubview(buttonStackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSimpleModel(product: Product) {
        descriptionView.updateSimpleModel(product)
        updateDescriptionPosition(withAnimation: true)
    }
    
    func updateModel(productDetails: ProductDetails, defaultSize: ProductDetailsSize?, defaultColor: ProductDetailsColor?) {
        descriptionView.updateModel(productDetails, defaultSize: defaultSize, defaultColor: defaultColor)
        imageDataSource.imageUrls = productDetails.images.map { $0.url }
        pageControl.numberOfPages = imageDataSource.imageUrls.count
        pageControl.invalidateIntrinsicContentSize()
        
        updateDescriptionPosition(withAnimation: true)
    }
    
    private func updateDescriptionPosition(withAnimation animation: Bool, animationDuration: Double = 0.3) {
        let newDescriptionOffset = descriptionVisible ? defaultDescriptionTopMargin - bounds.height : -(descriptionView.getHeightForHeader() + (contentInset?.bottom ?? 0))
        
        self.layoutIfNeeded()
        
        self.setNeedsLayout()
        UIView.animateWithDuration(animation ? animationDuration : 0) { [unowned self] in
            self.descriptionAndButtonsAlpha = 1
            self.descriptionTopConstraint?.updateOffset(newDescriptionOffset)
            self.layoutIfNeeded()
        }
    }
    
    func changeDescriptionVisibility(visible: Bool, animated: Bool, completion: () -> Void) {
        //todo
    }
    
    private func configureCustomConstraints() {
        imageCollectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionView.snp_makeConstraints { make in
            descriptionTopConstraint = make.top.equalTo(descriptionView.superview!.snp_bottom).constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().inset(defaultDescriptionTopMargin)
        }
        
        pageControl.snp_makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.leading.equalTo(10)
        }
        
        buttonStackView.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalTo(descriptionView.snp_top).offset(-8)
        }
        
        shareButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(shareButton.snp_width)
        }
        
        whishlistButton.snp_makeConstraints { make in
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(whishlistButton.snp_width)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageHeight = scrollView.frame.height
        pageControl.currentPage = Int(scrollView.contentOffset.y / pageHeight)
    }
}

extension ProductPageView {
    func didPanOnDescriptionView(panGestureRecognizer: UIPanGestureRecognizer) {
        let bottomOffset = descriptionView.tableView.frame.minY + (contentInset?.bottom ?? 0)
        let movableY = bounds.height - defaultDescriptionTopMargin - bottomOffset
        var moveY = panGestureRecognizer.translationInView(descriptionView).y
        
        switch panGestureRecognizer.state {
        case .Changed:
            if descriptionVisible && moveY < 0 { moveY = 0 }
            else if descriptionVisible && moveY > movableY { moveY = movableY }
            else if !descriptionVisible && moveY > 0 { moveY = 0 }
            else if !descriptionVisible && moveY < -movableY { moveY = -movableY }
            
            let newOffset = descriptionVisible ? (defaultDescriptionTopMargin - bounds.height) + moveY : -bottomOffset + moveY
            self.descriptionTopConstraint?.updateOffset(newOffset)
        case .Ended:
            let movedMoreThanHalf = descriptionVisible && moveY > movableY * 0.5 || !descriptionVisible && moveY < -movableY * 0.5
            
            let yVelocity = panGestureRecognizer.velocityInView(descriptionView).y
            let movedFasterForward = descriptionVisible && yVelocity > descriptionDragVelocityThreshold || !descriptionVisible && yVelocity < -descriptionDragVelocityThreshold
            let movedFasterBackward = descriptionVisible && yVelocity < -descriptionDragVelocityThreshold || !descriptionVisible && yVelocity > descriptionDragVelocityThreshold
            
            if movedFasterForward || (movedMoreThanHalf && !movedFasterBackward){
                descriptionVisible = !descriptionVisible
            }
            
            updateDescriptionPosition(withAnimation: true, animationDuration: 0.2)
        default: break
        }
    }
    
    func didTapOnDescriptionView(tapGestureRecognizer: UITapGestureRecognizer) {
        descriptionVisible = !descriptionVisible
        updateDescriptionPosition(withAnimation: true, animationDuration: 0.4)
    }
}
