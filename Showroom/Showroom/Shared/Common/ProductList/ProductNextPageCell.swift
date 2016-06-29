import UIKit

final class ProductNextPageCell: UICollectionViewCell {
    let loadingIndicator = LoadingIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loadingIndicator)
        
        loadingIndicator.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}