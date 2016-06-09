import Foundation
import UIKit

class ProductDescriptionLineCell: UITableViewCell {
    static let titleFont = UIFont(fontType: .Description)
    static let leftMargin: CGFloat = 31
    static let textCircleMargin: CGFloat = 20
    static let circleDiameter: CGFloat = 4
    static let verticalMargin: CGFloat = 2
    
    let circleView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        circleView.layer.cornerRadius = ProductDescriptionLineCell.circleDiameter * 0.5
        circleView.backgroundColor = UIColor(named: .Black)
        
        titleLabel.font = UIFont(fontType: .Description)
        titleLabel.textColor = UIColor(named: .Black)
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(circleView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getHeight(forWidth width: CGFloat, title: String) -> CGFloat {
        let widthLeft = width - ProductDescriptionLineCell.leftMargin - ProductDescriptionLineCell.circleDiameter - ProductDescriptionLineCell.textCircleMargin
        return ceil(title.heightWithConstrainedWidth(widthLeft, font: ProductDescriptionLineCell.titleFont)) + verticalMargin * 2
    }
    
    private func configureCustomConstraints() {
        circleView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(ProductDescriptionLineCell.leftMargin)
            make.top.equalToSuperview().offset(6 + ProductDescriptionLineCell.verticalMargin)
            make.width.equalTo(ProductDescriptionLineCell.circleDiameter)
            make.height.equalTo(circleView.snp_width)
        }
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(circleView.snp_trailing).offset(ProductDescriptionLineCell.textCircleMargin)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(ProductDescriptionLineCell.verticalMargin)
            make.bottom.equalToSuperview().inset(ProductDescriptionLineCell.verticalMargin)
        }
    }
}
