import UIKit

class TouchIndicatorView: UIView {
    
    private let diameter: CGFloat = 25.0
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        
        backgroundColor = UIColor(named: .Manatee)
        
        touchUp()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.cornerRadius = diameter / 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown() {
        alpha = 0.3
    }
    
    func touchUp() {
        alpha = 0.0
    }
    
    func animateDoubleTap(completion completion: ((Bool) -> ())? = nil) {
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.touchDown()
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: [], animations: { [unowned self] _ in
            UIView.setAnimationRepeatCount(2.0)
            self.transform = CGAffineTransformIdentity
            
            }, completion: { [weak self] success in
                guard let `self` = self else { return }
                
                self.touchUp()
                completion?(success)
        })
    }
}