import UIKit

protocol ProductErrorPageCellDelegate: class {
    func productErrorCellDidTapRetry(cell: ProductErrorPageCell)
}

final class ProductErrorPageCell: UICollectionViewCell {
    private let retryButton = UIButton()
    
    weak var delegate: ProductErrorPageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: .Gray)
        
        retryButton.applyBigCircleStyle()
        retryButton.setImage(UIImage(asset: .Refresh), forState: .Normal)
        retryButton.addTarget(self, action: #selector(ProductErrorPageCell.didTapRetryButton), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(retryButton)
        
        retryButton.snp_makeConstraints { make in
            make.center.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, Dimensions.defaultMargin, 0))
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