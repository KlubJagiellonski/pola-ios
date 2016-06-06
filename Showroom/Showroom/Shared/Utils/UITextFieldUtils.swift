import Foundation
import UIKit

extension UITextField {
    func applyPlainStyle() {
        self.font = UIFont(fontType: .Input)
        self.textAlignment = .Center
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1;
    }
}