import Foundation
import UIKit

class SettingsViewController: UIViewController {
    let productActionHeight = CGFloat(216)
    
    let blurButton = UIButton()
    let iconsButton = UIButton()
    
    let dropUpAnimator: DropUpActionAnimator
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        dropUpAnimator = DropUpActionAnimator(height: productActionHeight)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconsButton.setTitle("TOGGLE TAB BAR ICONS", forState: .Normal)
        iconsButton.applySimpleBlueStyle()
        iconsButton.addTarget(self, action: #selector(SettingsViewController.iconsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(iconsButton)
        
        configureCustomConstraints()
    }
    
    func iconsButtonPressed(sender: UIButton!) {
        let currentBarIconsVersion = (tabBarController as! MainTabViewController).iconsVersion
        (tabBarController as! MainTabViewController).iconsVersion = (currentBarIconsVersion == .Full ? .Line : .Full)
    }
    
    func configureCustomConstraints() {
        iconsButton.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.centerX.equalToSuperview()
        }
    }
}