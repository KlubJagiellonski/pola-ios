import UIKit
import SnapKit

class TabBarItemBadgeContainerView: UIView {
    private let animationDuration = 0.3
    private let badgeVerticalOffset: CGFloat = 9.0
    private let basketBadgeHorizontalOffset: CGFloat = 22.0
    private let wishlistBadgeHorizontalOffset: CGFloat = 19.0
    
    private var wishlistConstraint: Constraint!

    private let basketBadge: TabBarItemBadge
    private let wishlistBadge: TabBarItemBadge
    
    var wishlistBadgeValue: UInt {
        didSet { setBadgeValue(oldValue: oldValue, newValue: wishlistBadgeValue, badge: wishlistBadge) }
    }
    
    var basketBadgeValue: UInt {
        didSet { setBadgeValue(oldValue: oldValue, newValue: basketBadgeValue, badge: basketBadge) }
    }
    
    init() {
        basketBadgeValue = 0
        basketBadge = TabBarItemBadge(value: String(basketBadgeValue))
        
        wishlistBadgeValue = 0
        wishlistBadge = TabBarItemBadge(value: String(wishlistBadgeValue))
        
        super.init(frame: CGRectZero)
        
        backgroundColor = nil
        userInteractionEnabled = false
        
        basketBadge.hidden = true
        wishlistBadge.hidden = true
        
        addSubview(basketBadge)
        addSubview(wishlistBadge)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCustomConstraints() {
        basketBadge.snp_makeConstraints { make in
            make.centerY.equalToSuperview().inset(-badgeVerticalOffset)
            make.trailing.equalTo(self.snp_centerX).offset(basketBadgeHorizontalOffset)
        }
        
        wishlistBadge.snp_makeConstraints { make in
            make.centerY.equalToSuperview().inset(-badgeVerticalOffset)
            wishlistConstraint = make.trailing.equalTo(self.snp_centerX).constraint
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wishlistConstraint.updateOffset(self.bounds.width / 5.0 + wishlistBadgeHorizontalOffset)
        super.layoutSubviews()
    }
    
    private func setBadgeValue(oldValue oldValue: UInt, newValue: UInt, badge: TabBarItemBadge) {
        
        if newValue != 0 {
            
            if oldValue == 0 {
                // show
                badge.value = String(newValue)
                badge.invalidateIntrinsicContentSize()

                badge.transform = CGAffineTransformMakeScale(0, 0)
                badge.hidden = false
                badge.layer.removeAllAnimations()
                UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                    badge.transform = CGAffineTransformIdentity
                    }, completion: nil)
                
            } else {
                // change width
                badge.hidden = false
                badge.layer.removeAllAnimations()
                UIView.transitionWithView(badge.label, duration: animationDuration, options: [.TransitionCrossDissolve], animations: {
                    badge.value = String(newValue)
                    }, completion: nil)
                
                UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                    badge.invalidateIntrinsicContentSize()
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                    }, completion: nil)
            }
            
        } else if oldValue != 0 {
            // hide
            badge.layer.removeAllAnimations()
            UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                badge.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { finished in
                    guard finished else { return }
                    badge.hidden = true
                    badge.transform = CGAffineTransformIdentity
                    badge.value = String(newValue)
            })
        }
    }
}

class TabBarItemBadge: UIView {
    private let horizontalInset: CGFloat = 3.0
    private let verticalInset: CGFloat = 0.0
    
    private let label = UILabel()
    private let roundedBackgroundView = UIView()
    
    var value: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }
    
    init(value: String) {
        super.init(frame: CGRectZero)
        
        clipsToBounds = false
        
        roundedBackgroundView.clipsToBounds = true
        roundedBackgroundView.backgroundColor = UIColor(named: .RedViolet)
        addSubview(roundedBackgroundView)
        
        label.text = value
        label.clipsToBounds = false
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont(fontType: .TabBarBadge)
        addSubview(label)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1.0)
        }
        roundedBackgroundView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedBackgroundView.layer.cornerRadius = bounds.size.height * 0.5
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = label.intrinsicContentSize()
        size.height += verticalInset * 2
        size.width += horizontalInset * 2

        size.width = max(size.width, size.height)
        return size
    }
}
