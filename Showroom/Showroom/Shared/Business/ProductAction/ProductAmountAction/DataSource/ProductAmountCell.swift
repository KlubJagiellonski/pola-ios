import UIKit

class ProductAmountCell: UITableViewCell {
    private let amountLabel = UILabel()
    private let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        amountLabel.font = UIFont(fontType: .ProductActionOption)
        contentView.addSubview(amountLabel)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(withAmount amount: Int) {
        amountLabel.text = amount == 0 ? tr(.BasketAmount0) : String(amount)
    }
    
    func configureCustomConstraints() {
        amountLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
}