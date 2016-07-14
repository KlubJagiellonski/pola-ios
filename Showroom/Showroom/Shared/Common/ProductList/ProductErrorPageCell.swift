import UIKit

protocol ProductErrorPageCellDelegate: class {
    func productErrorCellDidTapRetry(cell: ProductErrorPageCell)
}

final class ProductErrorPageCell: UICollectionViewCell {
    private let errorLabel = UILabel()
    private let retryButton = UIButton()
    
    weak var delegate: ProductErrorPageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: .Gray)
        
        errorLabel.text = tr(.CommonErrorShort)
        errorLabel.font = UIFont(fontType: .Normal)
        errorLabel.textAlignment = .Center
        
        retryButton.applyBigCircleStyle()
        retryButton.setImage(UIImage(asset: .Refresh), forState: .Normal)
        retryButton.addTarget(self, action: #selector(ProductErrorPageCell.didTapRetryButton), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(errorLabel)
        contentView.addSubview(retryButton)
        
        configureCustomConstraints()
    }
    
    private func configureCustomConstraints() {
        errorLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        retryButton.snp_makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(Dimensions.bigCircleButtonDiameter)
            make.height.equalTo(retryButton.snp_width)
        }
    }
    
    func didTapRetryButton() {
        delegate?.productErrorCellDidTapRetry(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}