import Foundation
import UIKit
import SnapKit

class WishlistViewController: UIViewController {
    init(resolver: DiResolver) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //todo testcode remove it in future
        let indicator = LoadingIndicator()
        view.addSubview(indicator)
        indicator.snp_makeConstraints { make in
            make.center.equalToSuperview().offset(CGPointMake(0, -100))
        }
        
        let showOnboardingButton = UIButton()
        showOnboardingButton.title = "SHOW ONBOARDING"
        showOnboardingButton.applyPlainStyle()
        showOnboardingButton.addTarget(self, action: #selector(WishlistViewController.didTapShowOnboarding(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(showOnboardingButton)
        showOnboardingButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
        
        let showStartButton = UIButton()
        showStartButton.title = "SHOW START"
        showStartButton.applyPlainStyle()
        showStartButton.addTarget(self, action: #selector(WishlistViewController.didTapShowStart(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(showStartButton)
        showStartButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(showOnboardingButton.snp_bottom)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //todo testcode remove it in future
        let indicator = view.subviews[0] as! LoadingIndicator
        indicator.startAnimation()
    }
    
    // TODO: Remove when tested
    @objc private func didTapShowOnboarding(sender: UIButton) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowOnboarding))
    }
    
    @objc private func didTapShowStart(sender: UIButton) {
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowStart))
    }
}
