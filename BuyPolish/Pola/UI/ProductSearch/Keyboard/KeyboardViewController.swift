import UIKit
import AudioToolbox

@objc(BPKeyboardViewControllerDelegate)
protocol KeyboardViewControllerDelegate: class {
    func keyboardViewController(_ keyboardViewController: KeyboardViewController, didConfirmWithCode code: String)
}

@objc(BPKeyboardViewController)
class KeyboardViewController: UIViewController {
    
    @objc
    weak var delegate: KeyboardViewControllerDelegate?
    
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
            code.isValidBarcode() {
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
