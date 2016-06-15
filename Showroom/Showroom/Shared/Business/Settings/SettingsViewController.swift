import Foundation
import UIKit

class SettingsViewController: UIViewController {
    let productActionHeight = CGFloat(216)
    
    let iconsButton = UIButton()
    let tabBarVisibleButton = UIButton()
    let incrementBadgeButton = UIButton()
    let decrementBadgeButton = UIButton()
    
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
        
        tabBarVisibleButton.setTitle("TOGGLE TAB BAR VISIBLE", forState: .Normal)
        tabBarVisibleButton.applySimpleBlueStyle()
        tabBarVisibleButton.addTarget(self, action: #selector(SettingsViewController.toggleTabBar(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(tabBarVisibleButton)
        
        incrementBadgeButton.setTitle("BASKET BADGE +1", forState: .Normal)
        incrementBadgeButton.applySimpleBlueStyle()
        incrementBadgeButton.addTarget(self, action: #selector(SettingsViewController.incrementButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(incrementBadgeButton)
        
        decrementBadgeButton.setTitle("BASKET BADGE -1", forState: .Normal)
        decrementBadgeButton.applySimpleBlueStyle()
        decrementBadgeButton.addTarget(self, action: #selector(SettingsViewController.decrementButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(decrementBadgeButton)
        
        configureCustomConstraints()
    }
    
    func iconsButtonPressed(sender: UIButton!) {
        (tabBarController as! MainTabViewController).iconsVersion.toggle()
    }
    
    func toggleTabBar(sender: UIButton!) {
        if (tabBarController as! MainTabViewController).appearance == .Visible {
            (tabBarController as! MainTabViewController).updateTabBarAppearance(.Hidden)
        } else {
            (tabBarController as! MainTabViewController).updateTabBarAppearance(.Visible)
        }
    }
    
    func incrementButtonPressed(sender: UIButton!) {
        (tabBarController as! MainTabViewController).basketBadgeValue += 1
    }
    
    func decrementButtonPressed(sender: UIButton!) {
        guard (tabBarController as! MainTabViewController).basketBadgeValue > 0 else { return }
        (tabBarController as! MainTabViewController).basketBadgeValue -= 1
    }    
    
    func configureCustomConstraints() {
        iconsButton.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tabBarVisibleButton.snp_makeConstraints { make in
            make.top.equalTo(iconsButton.snp_bottom)
            make.centerX.equalToSuperview()
        }

        incrementBadgeButton.snp_makeConstraints { make in
            make.top.equalTo(tabBarVisibleButton.snp_bottom)
            make.centerX.equalToSuperview()
        }

        decrementBadgeButton.snp_makeConstraints { make in
            make.top.equalTo(incrementBadgeButton.snp_bottom)
            make.centerX.equalToSuperview()
        }
    }
}