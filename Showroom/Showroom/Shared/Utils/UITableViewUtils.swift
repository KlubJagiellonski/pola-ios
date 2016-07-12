import Foundation
import UIKit

extension UITableView {
    var extraSeparatorsEnabled: Bool {
        set { tableFooterView = newValue ? nil : UIView() }
        get { return tableFooterView == nil }
    }
}

extension UITableViewCell {
    func removeSeparatorInset() {
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
    }
}