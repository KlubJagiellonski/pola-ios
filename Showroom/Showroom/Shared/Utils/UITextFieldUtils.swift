import Foundation
import UIKit

extension UITextField {
    func applyPlainStyle() {
        self.font = UIFont(fontType: .Input)
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1;
    }
    
    
    var notEmptyText: String? {
        return text!.isEmpty ? nil : text
    }
}