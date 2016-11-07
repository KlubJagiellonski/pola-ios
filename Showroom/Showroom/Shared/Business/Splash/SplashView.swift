import Foundation
import UIKit

class SplashView: UIView {
    private let animationDuration: NSTimeInterval = 2
    
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView(image: UIImage(asset: .Logo))
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            backgroundImageView.image = UIImage(asset: .SplashImage4s)
        case .iPhone5:
            backgroundImageView.image = UIImage(asset: .SplashImage5s)
        case .iPhone6:
            backgroundImageView.image = UIImage(asset: .SplashImage6)
        case .iPhone6Plus:
            backgroundImageView.image = UIImage(asset: .SplashImage6p)
        default:
            backgroundImageView.image = UIImage(asset: .SplashImage6)
        }
        
        addSubview(backgroundImageView)
        addSubview(logoImageView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(completion: (Bool) -> ()) {
        UIView.animateKeyframesWithDuration(animationDuration, delay: 0, options: [], animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.7) { [unowned self] in
                self.logoImageView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }
            UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2) { [unowned self] in
                self.alpha = 0.0
            }
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.5) { [unowned self] in
                self.backgroundImageView.alpha = 0.0
            }
            }, completion: completion)
    }
    
    private func configureCustomConstraints() {
        backgroundImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
