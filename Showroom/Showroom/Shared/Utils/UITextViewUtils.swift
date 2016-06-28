import Foundation
import UIKit

extension UITextView {
    func applyPlainStyle() {
        self.font = UIFont(fontType: .InputLarge)
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1;
    }
}
