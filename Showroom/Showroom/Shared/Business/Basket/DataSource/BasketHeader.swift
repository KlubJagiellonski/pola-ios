import Foundation
import UIKit

class BasketHeader: UITableViewHeaderFooterView {
    static let headerHeight: CGFloat = 34
    
    let headerLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        headerLabel.font = UIFont(fontType: .FormBold)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(headerLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        headerLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview()
        }
    }
}
