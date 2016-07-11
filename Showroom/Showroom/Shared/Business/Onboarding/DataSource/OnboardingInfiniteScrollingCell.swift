import UIKit

class OnboardingInfiniteScrollingCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        contentView.backgroundColor = UIColor.blueColor()
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        
    }
}