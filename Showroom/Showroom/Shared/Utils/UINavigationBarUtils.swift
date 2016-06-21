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
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    }
    
    func applyTranslucentStyle() {
        translucent = true
        titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(named: .Black),
            NSFontAttributeName: UIFont(fontType: .NavigationBar)
        ]
        tintColor = UIColor(named: .Black)
        shadowImage = UIImage()
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
    }
}
