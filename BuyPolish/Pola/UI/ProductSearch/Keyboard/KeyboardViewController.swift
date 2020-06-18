import AudioToolbox
import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(_ keyboardViewController: KeyboardViewController, didConfirmWithCode code: String)
}

final class KeyboardViewController: UIViewController {
    let barcodeValidator: BarcodeValidator

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
        castedView.textView.removeButton.addTarget(self, action: #selector(playSoundAtRemove), for: .touchUpInside)
    }

    @objc
    private func enterNumber(sender: UIButton) {
        playSound()
        let number = sender.tag
        castedView.textView.insert(value: number)
        castedView.textView.hideErrorMessage()
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

    @objc
    private func playSoundAtRemove() {
        playSound()
    }

    private func playSound() {
        AudioServicesPlaySystemSound(1104)
    }
}
