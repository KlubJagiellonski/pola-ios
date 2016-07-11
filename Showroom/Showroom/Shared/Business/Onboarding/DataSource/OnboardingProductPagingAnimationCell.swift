import UIKit

class OnboardingProductPagingAnimationCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor.redColor()
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        
    }
}