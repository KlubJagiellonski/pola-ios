import UIKit

extension UIAlertView {
    class func showErrorAlert(_ errorMessage: String) -> UIAlertView {
        let alertView = UIAlertView(title: R.string.localizable.ouch(),
                                    message: errorMessage,
                                    delegate: nil,
                                    cancelButtonTitle: R.string.localizable.dismiss())
        alertView.show()
        return alertView
    }
}
