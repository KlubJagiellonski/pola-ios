import UIKit

extension UIButton {
    func setReportType(_ reportType: AskForReport.ButtonType) {
        switch reportType {
        case .red:
            setTitleColor(Theme.clearColor, for: .normal)
            setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        case .white:
            layer.borderColor = Theme.actionColor.cgColor
            layer.borderWidth = 1
            setTitleColor(Theme.actionColor, for: .normal)
            setTitleColor(Theme.clearColor, for: .highlighted)
            setBackgroundImage(UIImage.image(color: UIColor.clear), for: .normal)
            setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .highlighted)
        }
    }
}
