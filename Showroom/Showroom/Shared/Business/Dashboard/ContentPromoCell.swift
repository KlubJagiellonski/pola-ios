import Foundation
import UIKit

extension ContentPromoTextType {
    func gradientColors() -> [CGColor] {
        switch self {
        case .Black:
            return [UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor, UIColor.whiteColor().CGColor]
        default:
            return [UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor, UIColor.blackColor().CGColor]
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

// MARK: - Cells

class ContentPromoCell: UITableViewCell {
    static let photoRatio = 0.75
    
    let promoImageView = UIImageView()
    let textContainerView = ContentPromoTextContainerView()
    let footerView = UIView()
    
    var captionContainerHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
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
        return width / CGFloat(photoRatio)
    }
    
    func updateData(contentPromo: ContentPromo) {
        let image = contentPromo.image
        promoImageView.loadImageFromUrl(image.url, size: contentView.frame.size)
        
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
            make.height.equalTo(promoImageView.snp_width).dividedBy(ContentPromoCell.photoRatio)
        }
        
        textContainerView.snp_makeConstraints { make in
            make.bottom.equalTo(promoImageView.snp_bottom)
            make.leading.equalTo(promoImageView)
            make.trailing.equalTo(promoImageView)
        }
        
        footerView.snp_makeConstraints { make in
            make.top.equalTo(promoImageView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        return width / CGFloat(photoRatio) + ContentPromoCaptionContainerView.getHeight(forWidth: width, model: model)
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
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let backgroundGradient = CAGradientLayer()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        layer.addSublayer(backgroundGradient)
        
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        
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
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        subtitleLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

class ContentPromoCaptionContainerView: UIView {
    static let titleFont = UIFont.boldSystemFontOfSize(16)
    static let subtitleFont = UIFont.systemFontOfSize(14)
    
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
        let titleHeight = caption.title.heightWithConstrainedWidth(width, font: ContentPromoCaptionContainerView.titleFont)
        let subtitleHeight = caption.subtitle.heightWithConstrainedWidth(width, font: ContentPromoCaptionContainerView.subtitleFont)
        return titleHeight + subtitleHeight
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        subtitleLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}