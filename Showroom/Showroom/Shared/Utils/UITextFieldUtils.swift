import Foundation
import UIKit

extension UITextField {
    func applyPlainStyle() {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1;
    }
}