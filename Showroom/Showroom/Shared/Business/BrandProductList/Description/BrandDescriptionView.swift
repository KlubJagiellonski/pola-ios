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
    private var imageUrlToLoadOnLayoutPass: (imageUrl: String, lowResImageUrl: String?)?
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
        
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        
        imageGradient.opacity = 0
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
        
        layoutGradient()
        
        if let loadImageUrls = imageUrlToLoadOnLayoutPass where bounds.width > 0 && bounds.height > 0 {
            loadImage(loadImageUrls.imageUrl, lowResImageUrl: loadImageUrls.lowResImageUrl)
            imageUrlToLoadOnLayoutPass = nil
        }
    }
    
    private func updateData(with brand: Brand) {
        if bounds.width > 0 && bounds.height > 0 {
            loadImage(brand.imageUrl, lowResImageUrl: brand.lowResImageUrl)
        } else {
            imageUrlToLoadOnLayoutPass = (brand.imageUrl, brand.lowResImageUrl)
        }
        
        titleLabel.text = brand.name
        let description = brand.description.markdownToAttributedString()
        descriptionTextView.attributedText = description
    }
    
    private func loadImage(mainUrl: String, lowResImageUrl: String?) {
        backgroundImageView.loadImageWithLowResImage(mainUrl, lowResUrl: lowResImageUrl, width: bounds.width) { [weak self] image in
            guard let `self` = self else { return }
            UIView.animateWithDuration(0.1, delay: 0, options: .TransitionCrossDissolve, animations: {
                self.backgroundImageView.image = image
            }) { _ in
                guard self.imageGradient.opacity != 1.0 else { return }
                self.layoutGradient()
                self.imageGradient.opacity = 1.0
            }
        }
    }
    
    private func layoutGradient() {
        let gradientHeight = bounds.width
        let gradientY = self.backgroundImageView.frame.height == 0 ? self.frame.height - gradientHeight : backgroundImageView.frame.maxY - gradientHeight
        imageGradient.frame = CGRectMake(0, gradientY, backgroundImageView.bounds.width, gradientHeight)
    }
    
    private func configureCustomConstraints() {
        backgroundImageView.snp_makeConstraints { make in
            backgroundImageViewTopConstraint = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
