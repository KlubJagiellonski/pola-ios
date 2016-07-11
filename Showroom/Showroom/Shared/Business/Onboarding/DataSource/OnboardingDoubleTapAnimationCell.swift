import UIKit

class OnboardingDoubleTapAnimationCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor.greenColor()
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        
    }
}