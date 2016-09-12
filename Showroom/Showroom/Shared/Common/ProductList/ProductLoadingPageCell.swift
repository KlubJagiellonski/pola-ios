import UIKit

final class ProductLoadingPageCell: UICollectionViewCell {
    let loadingIndicator = LoadingIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loadingIndicator)
        
        loadingIndicator.snp_makeConstraints { make in
            make.center.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, Dimensions.defaultMargin, 0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}