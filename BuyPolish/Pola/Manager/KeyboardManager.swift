import UIKit

protocol KeyboardManagerDelegate: AnyObject {
    func keyboardWillShow(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions)
    func keyboardWillHide(animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions)
}

protocol KeyboardManager: AnyObject {
    var delegate: KeyboardManagerDelegate? { get set }
    func turnOn()
    func turnOff()
}

final class NotificationCenterKeyboardManager: KeyboardManager {
    weak var delegate: KeyboardManagerDelegate?
    private let notificationCenter: NotificationCenter
    private var notificationTokens = [NSObjectProtocol]()

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    deinit {
        turnOff()
    }

    func turnOn() {
        guard notificationTokens.isEmpty else {
            return
        }

        let willShownToken =
            notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                           object: nil,
                                           queue: .main,
                                           using: { self.keyboardWillShow(notification: $0) })
        let willHideToken =
            notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                           object: nil,
                                           queue: .main,
                                           using: { self.keyboardWillHide(notification: $0) })
        notificationTokens.append(contentsOf: [willShownToken, willHideToken])
    }

    func turnOff() {
        notificationTokens.forEach { self.notificationCenter.removeObserver($0) }
        notificationTokens.removeAll()
    }

    private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationOptions = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        delegate?.keyboardWillHide(animationDuration: animationDuration,
                                   animationOptions: .init(rawValue: animationOptions))
    }

    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let animationOptions = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        delegate?.keyboardWillShow(height: keyboardRect.size.height,
                                   animationDuration: animationDuration,
                                   animationOptions: .init(rawValue: animationOptions))
    }
}
