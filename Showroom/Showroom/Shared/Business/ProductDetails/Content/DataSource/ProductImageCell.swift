import Foundation
import UIKit
import SnapKit

class ProductImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    var topConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        imageView.contentMode = .ScaleAspectFill
        
        contentView.addSubview(imageView)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp_makeConstraints { make in
            topConstraint = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp_width).dividedBy(Dimensions.defaultImageRatio)
        }
    }
}