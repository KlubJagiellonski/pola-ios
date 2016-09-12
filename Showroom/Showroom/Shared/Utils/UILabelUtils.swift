import UIKit

extension ExtendedLabel {
    func applyFormValidationStyle() {
        font = UIFont(fontType: .Description)
        textColor = UIColor(named: .White)
        backgroundColor = UIColor(named: .Black)
        textPadding = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 5)
    }
}