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
}
