import UIKit
import SnapKit

final class TrendHeaderCell: UIView {
    private static let descriptionFont = UIFont(fontType: .Normal)
    private static let textTopOffset: CGFloat = 143
    
    private let backgroundImageView = UIImageView()
    private let imageGradient = CAGradientLayer()
    private let descriptionContainerView = UIView()
    private let descriptionLabel = UILabel()
    
    private var topBackgroundImageViewConstraint: Constraint?
    
    init() {
        super.init(frame: CGRectZero)
        
        imageGradient.colors = [UIColor(named: .White).colorWithAlphaComponent(0).CGColor, UIColor(named: .White).CGColor]
        
        descriptionContainerView.backgroundColor = UIColor(named: .White).colorWithAlphaComponent(0.9)
        
        descriptionLabel.font = TrendHeaderCell.descriptionFont
        descriptionLabel.numberOfLines = 0
        
        descriptionContainerView.addSubview(descriptionLabel)
        
        addSubview(backgroundImageView)
        backgroundImageView.layer.addSublayer(imageGradient)
        addSubview(descriptionContainerView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func height(forWidth width: CGFloat, andDescription description: String) -> CGFloat {
        let textWidth = width - 4 * Dimensions.defaultMargin
        let textHeight = description.heightWithConstrainedWidth(textWidth, font: TrendHeaderCell.descriptionFont)
        let textContainerHeight = ceil(TrendHeaderCell.textTopOffset + 2 * Dimensions.defaultMargin + textHeight)
        let imageHeight = ceil(width / CGFloat(Dimensions.defaultImageRatio))
        return max(textContainerHeight, imageHeight)
    }
    
    func updateData(withImageUrl imageUrl: String, description: String) {
        backgroundImageView.image = UIImage(asset: .Temp_trend) //todo remember to remove .Temp_trend image when we will get imageUrl
        descriptionLabel.text = description
    }
    
    func updateImagePosition(forYOffset yOffset: CGFloat, contentHeight: CGFloat) {
        let headerEndVisible = bounds.height < yOffset + contentHeight
        if !headerEndVisible || yOffset < 0 {
            topBackgroundImageViewConstraint?.updateOffset(yOffset)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientHeight = backgroundImageView.bounds.width
        imageGradient.frame = CGRectMake(0, backgroundImageView.bounds.height - gradientHeight, backgroundImageView.bounds.width, gradientHeight)
    }
    
    private func configureCustomConstraints() {
        backgroundImageView.snp_makeConstraints { make in
            topBackgroundImageViewConstraint = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(backgroundImageView.snp_width).dividedBy(Dimensions.defaultImageRatio)
        }
        
        descriptionContainerView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(TrendHeaderCell.textTopOffset)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.defaultMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}
