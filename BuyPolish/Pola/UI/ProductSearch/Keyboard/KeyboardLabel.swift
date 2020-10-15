import UIKit

protocol KeyboardLabelDelegate: AnyObject {
    func keyboardLabelIsPasteAvailable(_ label: KeyboardLabel, pasteboardContent: String?) -> Bool
    func keyboardLabelUserDidTapPaste(_ label: KeyboardLabel, pasteboardContent: String?)
    func keyboardLabelUserDidTapPasteAndActivate(_ label: KeyboardLabel, pasteboardContent: String?)
    func keyboardLabelUserDidRemoveContent(_ label: KeyboardLabel)
}

class KeyboardLabel: UILabel {
    let menu = UIMenuController.shared
    let pasteboard = UIPasteboard.general
    weak var delegate: KeyboardLabelDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
        font = Theme.titleFont
        textColor = Theme.defaultTextColor
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func showMenu(sender _: AnyObject?) {
        becomeFirstResponder()

        if !menu.isMenuVisible {
            let pasteAndActivate = UIMenuItem(title: R.string.localizable.pasteAndActivate(),
                                              action: #selector(pasteAndActivate(_:)))
            menu.menuItems = [pasteAndActivate]
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
        delegate?.keyboardLabelUserDidRemoveContent(self)
    }

    override func paste(_: Any?) {
        delegate?.keyboardLabelUserDidTapPaste(self, pasteboardContent: pasteboard.string)
        menu.setMenuVisible(false, animated: true)
    }

    @objc private func pasteAndActivate(_: Any?) {
        delegate?.keyboardLabelUserDidTapPasteAndActivate(self, pasteboardContent: pasteboard.string)
        menu.setMenuVisible(false, animated: true)
    }

    override func delete(_: Any?) {
        text = nil
        delegate?.keyboardLabelUserDidRemoveContent(self)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.copy),
             #selector(UIResponderStandardEditActions.cut),
             #selector(UIResponderStandardEditActions.delete):
            return textIsNotEmpty
        case #selector(UIResponderStandardEditActions.paste),
             #selector(KeyboardLabel.pasteAndActivate(_:)):
            return delegate?.keyboardLabelIsPasteAvailable(self, pasteboardContent: pasteboard.string) ?? false
        default:
            return false
        }
    }
}
