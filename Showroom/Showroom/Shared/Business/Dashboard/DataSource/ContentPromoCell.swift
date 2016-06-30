import Foundation
import UIKit

extension ContentPromoTextType {
    func gradientColors() -> [CGColor] {
        switch self {
        case .Black:
            return [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor]
        default:
            return [UIColor.blackColor().colorWithAlphaComponent(0).CGColor, UIColor.blackColor().CGColor]
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .Black:
            return UIColor.blackColor()
        default:
            return UIColor.whiteColor()
        }
    }
}

extension ContentPromoImage {
    var ratio: Double {
        return Double(width) / Double(height)
    }
}

// MARK: - Cells

class ContentPromoCell: UITableViewCell {
    static let textContainerHeight: CGFloat = 161
    
    let promoImageView = UIImageView()
    let textContainerView = ContentPromoTextContainerView()
    let footerView = UIView()
    
    var captionContainerHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        promoImageView.layer.masksToBounds = true
        promoImageView.contentMode = .ScaleAspectFill
        contentView.addSubview(promoImageView)
        
        contentView.addSubview(textContainerView)
        
        contentView.addSubview(footerView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getHeight(forWidth width: CGFloat, model: ContentPromo) -> CGFloat {
        return ceil(width / CGFloat(model.image.ratio)) + Dimensions.defaultMargin
    }
    
    func updateData(contentPromo: ContentPromo) {
        let image = contentPromo.image
        promoImageView.image = nil
        promoImageView.loadImageFromUrl(image.url, width: self.contentView.bounds.width)
        
        if let title = image.title, let subtitle = image.subtitle, let textColor = image.color {
            textContainerView.hidden = false
            textContainerView.backgroundGradient.colors = textColor.gradientColors()
            textContainerView.titleLabel.text = title
            textContainerView.titleLabel.textColor = textColor.color()
            textContainerView.subtitleLabel.text = subtitle
            textContainerView.subtitleLabel.textColor = textColor.color()
        } else {
            textContainerView.hidden = true
        }
    }
    
    private func configureCustomConstraints() {
        promoImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        textContainerView.snp_makeConstraints { make in
            make.height.equalTo(ContentPromoCell.textContainerHeight)
            make.bottom.equalTo(promoImageView.snp_bottom)
            make.leading.equalTo(promoImageView)
            make.trailing.equalTo(promoImageView)
        }
        
        footerView.snp_makeConstraints { make in
            make.top.equalTo(promoImageView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}

class ContentPromoWithCaptionCell: ContentPromoCell {
    let captionContainerView = ContentPromoCaptionContainerView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        footerView.addSubview(captionContainerView)
        
        configureCaptionCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func getHeight(forWidth width: CGFloat, model: ContentPromo) -> CGFloat {
        return super.getHeight(forWidth: width, model: model) + ContentPromoCaptionContainerView.getHeight(forWidth: width, model: model)
    }
    
    override func updateData(contentPromo: ContentPromo) {
        super.updateData(contentPromo)
        
        let caption = contentPromo.caption!
        captionContainerView.titleLabel.text = caption.title
        captionContainerView.subtitleLabel.text = caption.subtitle
    }
    
    func configureCaptionCustomConstraints() {
        captionContainerView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Subviews

class ContentPromoTextContainerView: UIView {
    static let bottomMargin:CGFloat = 19
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let backgroundGradient = CAGradientLayer()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        layer.addSublayer(backgroundGradient)
        
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        
        subtitleLabel.font = UIFont(fontType: .Italic)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        addSubview(subtitleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
    }
    
    private func configureCustomConstraints() {
        subtitleLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-ContentPromoTextContainerView.bottomMargin)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(subtitleLabel)
            make.trailing.equalTo(subtitleLabel)
            make.bottom.equalTo(subtitleLabel.snp_top)
        }
    }
}

class ContentPromoCaptionContainerView: UIView {
    static let topMargin:CGFloat = 3
    static let titleFont = UIFont(fontType: .Bold)
    static let subtitleFont = UIFont(fontType: .Italic)
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.whiteColor()
        
        titleLabel.font = ContentPromoCaptionContainerView.titleFont
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        
        subtitleLabel.font = ContentPromoCaptionContainerView.subtitleFont
        subtitleLabel.numberOfLines = 2
        addSubview(subtitleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getHeight(forWidth width: CGFloat, model: ContentPromo) -> CGFloat {
        let caption = model.caption!
        let widthWithMargin = width - 2 * Dimensions.defaultMargin
        let titleHeight = caption.title.heightWithConstrainedWidth(widthWithMargin, font: ContentPromoCaptionContainerView.titleFont)
        let subtitleHeight = caption.subtitle.heightWithConstrainedWidth(widthWithMargin, font: ContentPromoCaptionContainerView.subtitleFont)
        return topMargin + titleHeight + subtitleHeight
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(ContentPromoCaptionContainerView.topMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        subtitleLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
    }
}