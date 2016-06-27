import Foundation
import UIKit

protocol KeyboardHelperDelegate: class {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions)
}

class KeyboardHelper {
    private var registered = false
    private var animationInProgress = false
    weak var delegate: KeyboardHelperDelegate?
    
    deinit {
        unregister()
    }
    
    func register() {
        if !registered {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHelper.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHelper.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHelper.keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHelper.keyboardDidHide), name: UIKeyboardDidHideNotification, object: nil)
            animationInProgress = false
            registered = true
        }
    }
    
    func unregister() {
        if registered {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            animationInProgress = false
            registered = false
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if !animationInProgress {
            delegate?.keyboardHelperChangedKeyboardState(notification.beginFrame, toFrame: notification.endFrame, duration: notification.animationDuration, animationOptions: notification.animationOptions)
            animationInProgress = true
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if !animationInProgress {
            delegate?.keyboardHelperChangedKeyboardState(notification.beginFrame, toFrame: notification.endFrame, duration: notification.animationDuration, animationOptions: notification.animationOptions)
            animationInProgress = true
        }
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        animationInProgress = false
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        animationInProgress = false
    }
}

extension NSNotification {
    var beginFrame: CGRect { return userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue() }
    var endFrame: CGRect { return userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue() }
    var animationDuration: Double { return userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue }
    var animationOptions: UIViewAnimationOptions {
        let animationCurve = UIViewAnimationCurve(rawValue: Int(userInfo![UIKeyboardAnimationCurveUserInfoKey]!.intValue))!
        return animationOptionFromAnimationCurve(animationCurve)
    }
    func animationOptionFromAnimationCurve(animationCurve: UIViewAnimationCurve) -> UIViewAnimationOptions {
        switch animationCurve {
        case .EaseIn:
            return UIViewAnimationOptions.CurveEaseIn
        case .EaseInOut:
            return UIViewAnimationOptions.CurveEaseInOut
        case .EaseOut:
            return UIViewAnimationOptions.CurveEaseOut
        case .Linear:
            return UIViewAnimationOptions.CurveLinear
        }
    }
}