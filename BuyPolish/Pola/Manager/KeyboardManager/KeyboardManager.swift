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
