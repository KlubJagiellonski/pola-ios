import UIKit

class ProductSizeCell: UITableViewCell {
    static let horizontalInset: CGFloat = 15
    static let separatorHeight: CGFloat = 1
    
    private let sizeLabel = UILabel()
    private let sizeUnavailableLabel = UILabel()
    private let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        sizeLabel.font = UIFont(fontType: .ProductActionOption)
        contentView.addSubview(sizeLabel)
        
        sizeUnavailableLabel.font = UIFont(fontType: .ProductActionOption)
        contentView.addSubview(sizeUnavailableLabel)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(productSize: ProductSize) {
        sizeLabel.text = String(productSize)
        
        if productSize.isAvailable {
            sizeLabel.textColor = UIColor(named: .Black)
            sizeUnavailableLabel.hidden = true
        } else {
            sizeLabel.textColor = UIColor(named: .DarkGray)
            sizeUnavailableLabel.hidden = false
            sizeUnavailableLabel.text = tr(.ProductActionSizeCellSizeUnavailable)
            sizeUnavailableLabel.textColor = UIColor(named: .DarkGray)
        }
    }
    
    func configureCustomConstraints() {
        sizeLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(ProductSizeCell.horizontalInset)
        }
        
        sizeUnavailableLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(sizeLabel.snp_trailing)
            make.trailing.equalToSuperview().inset(ProductSizeCell.horizontalInset)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(ProductSizeCell.separatorHeight)
        }
    }
}
