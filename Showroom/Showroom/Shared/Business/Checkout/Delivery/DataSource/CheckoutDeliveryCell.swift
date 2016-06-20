import UIKit

class CheckoutDeliveryInfoHeaderCell: UITableViewCell {
    let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None

        label.font = UIFont(fontType: .Description)
        contentView.addSubview(label)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
