import UIKit

class ProductColorCell: UITableViewCell {
    static let colorIconSide: CGFloat = 25
    static let iconToLabelDistance: CGFloat = 15
    static let separatorHeight: CGFloat = 1
    
    private let colorIconView = ColorIconView()
    private let colorLabel = UILabel()
    private let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(colorIconView)
        
        colorLabel.numberOfLines = 2
        colorLabel.font = UIFont(fontType: .ProductActionOption)
        contentView.addSubview(colorLabel)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(productColor: ProductColor) {
        colorIconView.setColorRepresentation(productColor.color)
        
        if productColor.isAvailable {
            colorIconView.alpha = 1
            colorLabel.textColor = UIColor(named: .Black)
            colorLabel.text = String(productColor)
        } else {
            colorIconView.alpha = 0.2
            colorLabel.textColor = UIColor(named: .DarkGray)
            colorLabel.text = String(productColor) + "\n" + tr(.ProductActionColorCellColorUnavailable)
        }
    }
    
    func configureCustomConstraints() {
        colorIconView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(ProductColorCell.colorIconSide)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.width.equalTo(ProductColorCell.colorIconSide)
        }
        
        colorLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(colorIconView.snp_trailing).offset(ProductColorCell.iconToLabelDistance)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(ProductColorCell.separatorHeight)
        }
    }
}
