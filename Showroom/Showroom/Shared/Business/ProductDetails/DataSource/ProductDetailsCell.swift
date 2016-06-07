import Foundation
import UIKit

class ProductDetailsCell: UICollectionViewCell {
    var pageView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            guard let page = pageView else { return }
            
            contentView.addSubview(page)
            page.snp_makeConstraints { make in
                make.edges.equalToSuperview()
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
     
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
