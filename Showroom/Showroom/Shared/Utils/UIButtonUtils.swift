import Foundation
import UIKit

extension UIButton {
    func applyBlueStyle() {
        self.backgroundColor = UIColor(named: .Blue)
        self.titleLabel!.font = UIFont(fontType: .Button)
    }
    
    func applyPlainStyle() {
        self.setTitleColor(UIColor(named: .Blue), forState: UIControlState.Normal)
        self.titleLabel!.font = UIFont(fontType: .List)
    }
}