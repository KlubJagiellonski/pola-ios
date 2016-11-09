import Foundation
import UIKit

extension ContentPromoTextType {
    private func gradientColors() -> [CGColor] {
        switch self {
        case .Black:
            return [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor]
        case .White:
            return [UIColor.blackColor().colorWithAlphaComponent(0).CGColor, UIColor.blackColor().CGColor]
        }
    }
    
    private func color() -> UIColor {
        switch self {
        case .Black:
            return UIColor.blackColor()
        case .White:
            return UIColor.whiteColor()
        }
    }
    
    private func playImage() -> UIImage {
        switch self {
        case .Black:
            return UIImage(asset: .Play_main_light)
        case .White:
            return UIImage(asset: .Play_main_dark)
        }
    }
}

extension ContentPromoImage {
    private var ratio: Double {
        return Double(width) / Double(height)
    }
}

// MARK: - Cells

class ContentPromoCell: UITableViewCell {
    static let textContainerHeight: CGFloat = 161
    
    private let promoImageView = UIImageView()
    private let textContainerView = ContentPromoTextContainerView()
    private let footerView = UIView()
    private let playImageView = UIImageView()

    var imageTag: Int {
        set { promoImageView.tag = newValue }
        get { return promoImageView.tag }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: .White)
        
        promoImageView.backgroundColor = backgroundColor
        promoImageView.layer.masksToBounds = true
        promoImageView.contentMode = .ScaleAspectFill
        
        playImageView.contentMode = .Center
        
        footerView.backgroundColor = backgroundColor
        
        contentView.addSubview(promoImageView)
        contentView.addSubview(textContainerView)
        contentView.addSubview(playImageView)
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
        promoImageView.loadImageFromUrl(image.url, width: Dimensions.contentPromoImageWidth)
        
        let previousTextContainerHiddenState = textContainerView.hidden
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
        
        if contentPromo.showPlayOverlay {
            if previousTextContainerHiddenState != textContainerView.hidden {
                configurePlayConstraints()
            }
            playImageView.hidden = false
            playImageView.image = image.color?.playImage() ?? UIImage(asset: .Play_main_light)
        } else {
            playImageView.hidden = true
        }
    }
    
    func refreshImageIfNeeded(withUrl url: String) {
        if !promoImageView.imageDownloadingInProgress {
            promoImageView.loadImageFromUrl(url, width: Dimensions.contentPromoImageWidth)
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
        
        configurePlayConstraints()
        
        footerView.snp_makeConstraints { make in
            make.top.equalTo(promoImageView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
    
    private func configurePlayConstraints() {
        playImageView.snp_remakeConstraints { make in
            make.top.equalToSuperview()
            if textContainerView.hidden {
                make.bottom.equalTo(promoImageView.snp_bottom)
            } else { 
                let offset = ContentPromoTextContainerView.bottomMargin + textContainerView.titleLabel.font.lineHeight + textContainerView.subtitleLabel.font.lineHeight
                make.bottom.equalTo(promoImageView.snp_bottom).offset(-offset)
            }
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

final class ContentPromoWithCaptionCell: ContentPromoCell {
    private let captionContainerView = ContentPromoCaptionContainerView()
    
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
    
    private func configureCaptionCustomConstraints() {
        captionContainerView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Subviews

final class ContentPromoTextContainerView: UIView {
    static let bottomMargin:CGFloat = 19
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let backgroundGradient = CAGradientLayer()
    
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

final class ContentPromoCaptionContainerView: UIView {
    static let topMargin:CGFloat = 3
    static let titleFont = UIFont(fontType: .Bold)
    static let subtitleFont = UIFont(fontType: .Italic)
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.whiteColor()
        
        titleLabel.backgroundColor = backgroundColor
        titleLabel.font = ContentPromoCaptionContainerView.titleFont
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        
        subtitleLabel.backgroundColor = backgroundColor
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
