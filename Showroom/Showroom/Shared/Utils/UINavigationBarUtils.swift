import Foundation
import UIKit

extension UINavigationBar {
    func applyWhiteStyle() {
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
