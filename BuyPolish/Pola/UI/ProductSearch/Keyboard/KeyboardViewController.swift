import UIKit
import AudioToolbox

@objc(BPKeyboardViewControllerDelegate)
protocol KeyboardViewControllerDelegate: class {
    func keyboardViewController(_ keyboardViewController: KeyboardViewController, didConfirmWithCode code: String)
}

@objc(BPKeyboardViewController)
class KeyboardViewController: UIViewController {
    
    let barcodeValidator: BarcodeValidator
    
    @objc
    weak var delegate: KeyboardViewControllerDelegate?
    
    @objc
    static func fromDiContainer() -> KeyboardViewController {
        DI.container.resolve(KeyboardViewController.self)!
    }

    init(barcodeValidator: BarcodeValidator) {
        self.barcodeValidator = barcodeValidator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var castedView: KeyboardView {
        view as! KeyboardView
    }
    
    override func loadView() {
        view = KeyboardView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        castedView.numberButtons.forEach({$0.addTarget(self, action: #selector(enterNumber(sender:)), for: .touchUpInside)})
        castedView.okButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        castedView.textView.removeButton.addTarget(self, action: #selector(playSoundAtRemove), for: .touchUpInside)
    }
    
    @objc
    func enterNumber(sender: UIButton) {
        playSound()
        let number = sender.tag
        castedView.textView.insert(value: number)
        castedView.textView.hideErrorMessage()
    }
    
    @objc
    func confirm() {
        playSound()
        if let code = castedView.textView.code,
            barcodeValidator.isValid(barcode: code) {
            delegate?.keyboardViewController(self, didConfirmWithCode: code)
        } else {
            castedView.textView.showErrorMessage()
        }
    }
    
    @objc
    func playSoundAtRemove() {
        playSound()
    }
    
    private func playSound() {
        AudioServicesPlaySystemSound(1104)
    }

}
