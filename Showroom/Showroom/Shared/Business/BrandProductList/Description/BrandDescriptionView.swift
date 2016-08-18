import UIKit
import CocoaMarkdown
import SnapKit

class BrandDescriptionView: UIView, ContentInsetHandler {
    private let additionalScrollBottomInset: CGFloat = 60
    
    private let backgroundImageView = BrandImageView()
    private let imageGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let textContainerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private var backgroundImageViewTopConstraint: Constraint?
    private var imageUrlToLoadOnLayoutPass: (imageUrl: String, lowResImageUrl: String?)?
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            guard contentInset != oldValue else { return }
            
            backgroundImageViewTopConstraint?.updateOffset(contentInset.top)
            scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom + additionalScrollBottomInset, contentInset.right)
        }
    }
    
    init(with brand: Brand) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.alpha = 0
        
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
            self.backgroundImageView.image = image
            UIView.animateWithDuration(0.4, delay: 0.1, options: .TransitionNone, animations: {
                self.backgroundImageView.alpha = 1
            }, completion: nil)
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

class BrandImageView: UIImageView {
    override func intrinsicContentSize() -> CGSize {
        guard let image = self.image else {
            return super.intrinsicContentSize()
        }
        
        return CGSizeMake(self.bounds.width, self.bounds.width * image.size.height / image.size.width)
    }
}
