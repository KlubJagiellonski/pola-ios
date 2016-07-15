import Foundation
import UIKit

extension UINavigationBar {
    func applyWhiteStyle() {
        barTintColor = UIColor(named: .White)
        translucent = false
        titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Black),
            NSFontAttributeName: UIFont(fontType: .NavigationBar)
        ]
        tintColor = UIColor(named: .Black)
        shadowImage = UIImage.fromColor(UIColor(named: .Manatee), size: CGSizeMake(1, Dimensions.defaultSeparatorThickness))
        setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        
        applyBackButtonStyle()
    }
    
    func applyTranslucentStyle() {
        translucent = true
        titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Black),
            NSFontAttributeName: UIFont(fontType: .NavigationBar)
        ]
        tintColor = UIColor(named: .Black)
        
        applyBackButtonStyle()
    }
    
    func applyWhitePopupStyle() {
        barTintColor = UIColor(named: .White)
        translucent = false
        titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Black),
            NSFontAttributeName: UIFont(fontType: .Bold)
        ]
        tintColor = UIColor(named: .Black)
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        
        applyBackButtonStyle()
    }
    
    func applyBackButtonStyle() {
        let image = UIImage(asset: .Ic_navigation_back)
        backIndicatorImage = image
        backIndicatorTransitionMaskImage = image
    }
}
