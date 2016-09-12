import UIKit

class ProductHeaderContainerCell: UICollectionViewCell {
    var headerContentView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let headerContentView = headerContentView {
                contentView.addSubview(headerContentView)
                headerContentView.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}
