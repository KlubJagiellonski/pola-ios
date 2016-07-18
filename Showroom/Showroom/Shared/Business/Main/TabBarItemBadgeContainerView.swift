import UIKit

class TabBarItemBadgeContainerView: UIView {
    let showHideDuration = 0.3

    let badge: TabBarItemBadge
    
    var badgeValue: UInt {
        didSet {
            if badgeValue != 0 {
                
                if oldValue == 0 {
                    // show
                    badge.value = String(badgeValue)
                    badge.transform = CGAffineTransformMakeScale(0, 0)
                    badge.hidden = false
                    UIView.animateWithDuration(showHideDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                        self.badge.transform = CGAffineTransformIdentity
                        }, completion: nil)
                    
                } else {
                    // change width
                    badge.hidden = false
                    badge.value = String(badgeValue)
                    UIView.animateWithDuration(showHideDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                            self.setNeedsLayout()
                            self.layoutIfNeeded()
                        }, completion: nil)
                }
                
            } else {
                // hide
                UIView.animateWithDuration(showHideDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                    self.badge.transform = CGAffineTransformMakeScale(0.01, 0.01)
                    }, completion: { finished in
                        self.badge.hidden = true
                        self.badge.transform = CGAffineTransformIdentity
                        self.badge.value = String(self.badgeValue)
                })
            }
        }
    }
    
    init() {
        badgeValue = 0
        badge = TabBarItemBadge(value: String(badgeValue))
        super.init(frame: CGRectZero)
        
        backgroundColor = nil
        userInteractionEnabled = false
        
        addSubview(badge)
        badge.hidden = true
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        badge.snp_makeConstraints { make in
            make.centerY.equalToSuperview().inset(-8.0)
            make.trailing.equalTo(self.snp_centerX).inset(21.0)
        }
    }
}

class TabBarItemBadge: UIView {
    let horizontalInset: CGFloat = 3.0
    let verticalInset: CGFloat = 0.0
    
    private let label = UILabel()
    private let roundedBackgroundView = UIView()
    
    var value: String {
        set {
            label.text = newValue
            invalidateIntrinsicContentSize()
        }
        
        get {
            return label.text ?? ""
        }
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
            make.edges.equalToSuperview()
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
        
        if size.width < size.height {
            size.width = size.height
        }
        return size
    }
}
