import Foundation
import UIKit

final class ProductFilterMultipleCell: UITableViewCell {
    private static let topValueOffset: CGFloat = 40
    private static let valueFont: UIFont = UIFont(fontType: .Normal)
    
    private let labelContentView = UIView()
    private let titleLabel = UILabel()
    private let goImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    private let valueLabel = UILabel()
    
    var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    
    var value: String? {
        set { valueLabel.text = newValue }
        get { return valueLabel.text }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        removeSeparatorInset()
        
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.textColor = UIColor(named: .Black)
        
        valueLabel.font = ProductFilterMultipleCell.valueFont
        valueLabel.textColor = UIColor(named: .Manatee)
        valueLabel.numberOfLines = 0
        
        labelContentView.addSubview(titleLabel)
        labelContentView.addSubview(goImageView)
        
        contentView.addSubview(labelContentView)
        contentView.addSubview(valueLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func height(forWidth width: CGFloat, andValue value: String?) -> CGFloat {
        guard let value = value else { return Dimensions.defaultCellHeight }
        let valueHeight = value.heightWithConstrainedWidth(width - 2 * Dimensions.defaultMargin, font: ProductFilterMultipleCell.valueFont)
        return ProductFilterMultipleCell.topValueOffset + valueHeight + Dimensions.defaultMargin
    }
    
    private func configureCustomConstraints() {
        labelContentView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Dimensions.defaultCellHeight)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        goImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        valueLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(ProductFilterMultipleCell.topValueOffset)
        }
    }
}
