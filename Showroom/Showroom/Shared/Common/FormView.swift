import UIKit

protocol FormView: UITextFieldDelegate {
    var contentValidators: [ContentValidator] { get set }
    
    func onFormReachedEnd()
    func validate(showResult showResult: Bool) -> Bool
    func hideErrors()
    func handleTextFieldReturn(textField: UITextField) -> Bool
}

extension FormView where Self: UIView {
    func validate(showResult showResult: Bool) -> Bool {
        if showResult {
            hideErrors()
        }
        
        var result = true
        for contentValidator in contentValidators {
            if !contentValidator.validate(showResult) {
                result = false
            }
        }
        return result
    }
    
    func hideErrors() {
        for contentValidator in contentValidators {
            contentValidator.hideError()
        }
    }
    
    func handleTextFieldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = self.viewWithTag(nextTag)
        if let nextTextField = nextResponder as? UITextField {
            if !nextTextField.enabled {
                return handleTextFieldReturn(nextTextField)
            }
        }
        if let responder = nextResponder {
            responder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            onFormReachedEnd()
        }
        return true
    }
}