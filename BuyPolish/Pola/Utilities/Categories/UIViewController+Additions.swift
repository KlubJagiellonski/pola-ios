import UIKit

extension UIViewController {
    func addCloseButton() {
        let closeButtonItem =
            UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: self, action: #selector(closeTapped))
        closeButtonItem.accessibilityLabel = R.string.localizable.accessibilityClose()
        navigationItem.rightBarButtonItem = closeButtonItem
    }

    @objc
    private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    func showAlert(message: String, dismissHandler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: R.string.localizable.ouch(),
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: R.string.localizable.dismiss(),
                                        style: .destructive,
                                        handler: { _ in
                                            guard let dismissHandler = dismissHandler else {
                                                return
                                            }
                                            dismissHandler()
                                        }))
        present(alertVC, animated: true, completion: nil)
    }
}
