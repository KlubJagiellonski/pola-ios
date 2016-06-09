import Foundation
import UIKit

class ProductDescriptionSimpleCell: UITableViewCell {
    let titleLabel = UILabel()
    let goImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    let topSeparator = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        topSeparator.backgroundColor = UIColor(named: .Separator)
        
        titleLabel.font = UIFont(fontType: .FormNormal)
        titleLabel.textColor = UIColor(named: .Black)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(goImageView)
        
        addSubview(topSeparator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        goImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        topSeparator.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
