import UIKit
import CocoaMarkdown
import SnapKit

class BrandDescriptionView: UIView, ExtendedView {
    private let additionalScrollBottomInset: CGFloat = 60
    
    private let backgroundImageView = UIImageView()
    private let imageGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let textContainerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private var backgroundImageViewTopConstraint: Constraint?
    
    var extendedContentInset: UIEdgeInsets? {
        didSet {
            let inset = extendedContentInset ?? UIEdgeInsetsZero
            
            backgroundImageViewTopConstraint?.updateOffset(inset.top)
            scrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + additionalScrollBottomInset, inset.right)
        }
    }
    
    init(with brand: Brand) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.contentMode = .ScaleAspectFill
        
        imageGradient.colors = [UIColor(named: .White).colorWithAlphaComponent(0).CGColor, UIColor(named: .White).CGColor]
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, additionalScrollBottomInset, 0)
        
        textContainerView.backgroundColor = UIColor(named: .White).colorWithAlphaComponent(0.9)
        
        titleLabel.font = UIFont(fontType: .FormBold)
    
        descriptionTextView.applyMarkdownStyle()
        
        updateData(with: brand)
        
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(descriptionTextView)
        
        scrollView.addSubview(textContainerView)
        
        addSubview(backgroundImageView)
        layer.addSublayer(imageGradient)
        addSubview(scrollView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientHeight = backgroundImageView.bounds.width
        imageGradient.frame = CGRectMake(0, backgroundImageView.frame.maxY - gradientHeight, backgroundImageView.bounds.width, gradientHeight)
    }
    
    private func updateData(with brand: Brand) {
        backgroundImageView.loadImageWithLowResImage(brand.imageUrl, lowResUrl: brand.lowResImageUrl)
        
        titleLabel.text = brand.name
        let description = brand.description.markdownToAttributedString()
        descriptionTextView.attributedText = description
    }
    
    private func configureCustomConstraints() {
        backgroundImageView.snp_makeConstraints { make in
            backgroundImageViewTopConstraint = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(backgroundImageView.snp_width).dividedBy(Dimensions.defaultBrandImageRatio)
        }
        
        scrollView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textContainerView.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(300, Dimensions.defaultMargin, Dimensions.defaultMargin, Dimensions.defaultMargin))
            make.width.equalTo(self).offset(-2 * Dimensions.defaultMargin)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        descriptionTextView.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(11)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}
