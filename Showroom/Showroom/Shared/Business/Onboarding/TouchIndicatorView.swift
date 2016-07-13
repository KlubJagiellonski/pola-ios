import UIKit

class TouchIndicatorView: UIView {
    
    init() {
        let diameter: CGFloat = 25.0
        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        
        backgroundColor = UIColor(named: .Manatee)
        alpha = 0.3
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.cornerRadius = diameter / 2.0
        
        hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateDoubleTap(completion completion: ((Bool) -> ())? = nil) {
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.hidden = false
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: [], animations: { [unowned self] _ in
            UIView.setAnimationRepeatCount(2.0)
            self.transform = CGAffineTransformIdentity
            
            }, completion: { [weak self] success in
                guard let `self` = self else { return }
                
                self.hidden = true
                completion?(success)                
        })
    }
}