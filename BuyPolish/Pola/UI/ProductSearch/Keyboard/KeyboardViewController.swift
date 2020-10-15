import AudioToolbox
import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(_ keyboardViewController: KeyboardViewController, didConfirmWithCode code: String)
}

final class KeyboardViewController: UIViewController {
    let barcodeValidator: BarcodeValidator
    fileprivate let barcode = KeyboardBarcode(code: "")

    weak var delegate: KeyboardViewControllerDelegate?

    init(barcodeValidator: BarcodeValidator) {
        self.barcodeValidator = barcodeValidator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var castedView: KeyboardView! {
        view as? KeyboardView
    }

    override func loadView() {
        view = KeyboardView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        castedView.numberButtons.forEach { $0.addTarget(self, action: #selector(enterNumber(sender:)), for: .touchUpInside) }
        castedView.okButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        castedView.textView.removeButton.addTarget(self, action: #selector(removeLastNumber), for: .touchUpInside)
        castedView.textView.codeLabel.delegate = self
        castedView.textView.codeLabel.accessibilityIdentifier =
            NSStringFromClass(KeyboardLabel.self)
    }

    @objc
    private func enterNumber(sender: UIButton) {
        playSound()
        let number = sender.tag
        barcode.append(number: number)
        castedView.textView.codeLabel.text = barcode.code
        updateCodeLabel()
        playSound()
    }

    @objc
    private func removeLastNumber() {
        playSound()
        barcode.removeLast()
        updateCodeLabel()
    }

    @objc
    private func confirm() {
        playSound()
        if let code = castedView.textView.code,
            barcodeValidator.isValid(barcode: code) {
            delegate?.keyboardViewController(self, didConfirmWithCode: code)
        } else {
            castedView.textView.showErrorMessage()
        }
    }

    private func playSound() {
        AudioServicesPlaySystemSound(1104)
    }

    fileprivate func updateCodeLabel() {
        castedView.textView.codeLabel.text = barcode.code
        castedView.textView.hideErrorMessage()
    }
}

extension KeyboardViewController: KeyboardLabelDelegate {
    func keyboardLabelIsPasteAvailable(_: KeyboardLabel, pasteboardContent: String?) -> Bool {
        let isPasteboardNotEmpty = pasteboardContent?.isNotEmpty ?? false
        return isPasteboardNotEmpty && barcode.isAppendable
    }

    func keyboardLabelUserDidTapPaste(_: KeyboardLabel, pasteboardContent: String?) {
        guard let pasteboardContent = pasteboardContent else {
            return
        }
        barcode.append(string: pasteboardContent)
        updateCodeLabel()
    }

    func keyboardLabelUserDidTapPasteAndActivate(_ label: KeyboardLabel, pasteboardContent: String?) {
        keyboardLabelUserDidTapPaste(label, pasteboardContent: pasteboardContent)
        confirm()
    }

    func keyboardLabelUserDidRemoveContent(_: KeyboardLabel) {
        barcode.removeAll()
        updateCodeLabel()
    }
}
