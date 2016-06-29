import UIKit

enum BadgeLabelType {
    case Discount
    case New
    case FreeDelivery
    case Premium
}

class BadgeLabel: UILabel {
    private let type: BadgeLabelType
    
    init(withType type: BadgeLabelType) {
        self.type = type
        super.init(frame: CGRectZero)
        
        switch type {
        case .Discount:
            backgroundColor = UIColor(named: .RedViolet)
            font = UIFont(fontType: .Badge)
            textColor = UIColor(named: .White)
            textAlignment = .Center
        case .New:
            backgroundColor = UIColor(named: .Black)
            font = UIFont(fontType: .Badge)
            textColor = UIColor(named: .White)
            textAlignment = .Center
            text = tr(.ProductListBadgeNew)
        case .FreeDelivery:
            backgroundColor = UIColor(named: .White).colorWithAlphaComponent(0.8)
            font = UIFont(fontType: .Badge)
            textColor = UIColor(named: .Black)
            textAlignment = .Center
            text = tr(.ProductListBadgeFreeDelivery)
        case .Premium:
            backgroundColor = UIColor(named: .Black).colorWithAlphaComponent(0.8)
            font = UIFont(fontType: .Badge)
            textColor = UIColor(named: .White)
            textAlignment = .Center
            text = tr(.ProductListBadgePremium)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        switch type {
        case .Discount, .New:
            return Dimensions.topBadgeSize
        case .FreeDelivery, .Premium:
            return CGSizeMake(UIViewNoIntrinsicMetric, Dimensions.bottomBadgeHeight)
        }
    }
}
