import UIKit

class KeyboardLabel: UILabel {
    let menu = UIMenuController.shared
    let pasteboard = UIPasteboard.general

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func showMenu(sender _: AnyObject?) {
        becomeFirstResponder()

        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }

    override func copy(_: Any?) {
        pasteboard.string = text
        menu.setMenuVisible(false, animated: true)
    }

    override func cut(_ sender: Any?) {
        copy(sender)
        text = nil
    }

    override func paste(_: Any?) {
        let barcode = KeyboardBarcode(code: nonNullText)
        barcode.append(string: pasteboard.string ?? "")
        text = barcode.code
        menu.setMenuVisible(false, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.copy):
            return textIsNotEmpty
        case #selector(UIResponderStandardEditActions.cut):
            return textIsNotEmpty
        case #selector(UIResponderStandardEditActions.paste):
            let barcode = KeyboardBarcode(code: nonNullText)
            let isPasteboardNotEmpty = pasteboard.string?.isNotEmpty ?? false
            return isPasteboardNotEmpty && barcode.isAppendable
        default:
            return false
        }
    }
}
