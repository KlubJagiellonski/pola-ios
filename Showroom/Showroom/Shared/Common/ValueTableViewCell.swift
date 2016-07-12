import Foundation
import UIKit

final class ValueTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let goImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    
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
        
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.textColor = UIColor(named: .Black)
        
        valueLabel.font = UIFont(fontType: .Normal)
        valueLabel.textColor = UIColor(named: .Manatee)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(goImageView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        valueLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        valueLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp_trailing).offset(Dimensions.defaultMargin)
        }
        goImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        goImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(valueLabel.snp_trailing).offset(10)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}
