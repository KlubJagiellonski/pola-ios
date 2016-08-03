import Foundation
import UIKit

class ContentPromoRecommendationsHeaderCell: UITableViewCell {
    static let insets = UIEdgeInsets(top: Dimensions.defaultMargin, left: Dimensions.defaultMargin, bottom: Dimensions.defaultMargin, right: Dimensions.defaultMargin)
    static let firstPartFont = UIFont(fontType: .Bold)
    static let secondPartFont = UIFont(fontType: .Italic)
    
    static var cellHeight: CGFloat {
        let firstPartHeight = tr(.DashboardRecommendationTitleFirstPart).heightWithConstrainedWidth(CGFloat.max, font: ContentPromoRecommendationsHeaderCell.firstPartFont)
        let secondPartHeight = tr(.DashboardRecommendationTitleSecondPart).heightWithConstrainedWidth(CGFloat.max, font: ContentPromoRecommendationsHeaderCell.secondPartFont)
        return ContentPromoRecommendationsHeaderCell.insets.top + max(firstPartHeight, secondPartHeight) + ContentPromoRecommendationsHeaderCell.insets.bottom
    }
    
    let firstPartLabel = UILabel()
    let secondPartLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstPartLabel.text = tr(.DashboardRecommendationTitleFirstPart)
        firstPartLabel.font = ContentPromoRecommendationsHeaderCell.firstPartFont
        firstPartLabel.textColor = UIColor(named: .Black)
        firstPartLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        
        secondPartLabel.text = tr(.DashboardRecommendationTitleSecondPart)
        secondPartLabel.font = ContentPromoRecommendationsHeaderCell.secondPartFont
        secondPartLabel.textColor = UIColor(named: .Black)
        
        contentView.addSubview(firstPartLabel)
        contentView.addSubview(secondPartLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        firstPartLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(ContentPromoRecommendationsHeaderCell.insets.left)
            make.top.equalToSuperview().offset(ContentPromoRecommendationsHeaderCell.insets.top)
            make.bottom.equalToSuperview().inset(ContentPromoRecommendationsHeaderCell.insets.bottom)
        }
        
        secondPartLabel.snp_makeConstraints { make in
            make.leading.equalTo(firstPartLabel.snp_trailing).offset(8)
            make.trailing.equalToSuperview().inset(ContentPromoRecommendationsHeaderCell.insets.right)
            make.baseline.equalTo(firstPartLabel)
        }
    }
}
