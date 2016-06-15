import Foundation
import UIKit

class BasketCountryCell: UITableViewCell {
    let countryNameLabel = UILabel()
    var ticked = false {
        didSet {
            accessoryView = ticked ? UIImageView(image: UIImage(named: "ic_tick")) : nil
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        countryNameLabel.font = UIFont(fontType: .FormNormal)
        countryNameLabel.textColor = UIColor(named: .Black)
        
        contentView.addSubview(countryNameLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        countryNameLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(48)
            make.centerY.equalToSuperview()
        }
    }
}
