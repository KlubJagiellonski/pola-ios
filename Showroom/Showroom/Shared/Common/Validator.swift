import Foundation
import UIKit
import ObjectiveC

// MARK:- Validators
@objc protocol Validator {
    var failedMessage: String? { get }
    
    func validate(currentValue: AnyObject?) -> Bool
}

class NotEmptyValidator: Validator {
    @objc var failedMessage: String?
    private var messageForEmpty: String?
    
    @objc func validate(currentValue: AnyObject?) -> Bool {
        failedMessage = nil
        guard let text: String? = currentValue as? String else { fatalError("NotEmptyValidator cannot handle different type than String") }
        
        if text == nil || text!.characters.count == 0 {
            failedMessage = messageForEmpty ?? tr(.ValidatorNotEmpty)
            return false
        }
        
        return true
    }
    
    convenience init(messageForEmpty: String?) {
        self.init()
        self.messageForEmpty = messageForEmpty
    }
}

class SelectionRequiredValidator: Validator {
    @objc var failedMessage: String?
    private var messageForNotSelected: String
    
    init(messageForNotSelected: String) {
        self.messageForNotSelected = messageForNotSelected
    }
    
    @objc func validate(currentValue: AnyObject?) -> Bool {
        failedMessage = nil
        guard let selected: Bool = currentValue as? Bool else { fatalError("SelectionRequiredValidator cannot handle different type than Bool") }
        
        if !selected {
            failedMessage = messageForNotSelected
            return false
        }
        
        return true
    }
}

// MARK:- ContentValidator

protocol ContentValidator {
    func getValue() -> AnyObject?
    func showError(error: String)
    func hideError()
    func validate(showResult: Bool) -> Bool
}

private struct ContentValidatorAssociatedKeys {
    static var Validators = "showroom_validators"
}

extension ContentValidator where Self: UIView { // contains text field
    
    var validators: [Validator] {
        let optionalValidators = objc_getAssociatedObject(self, &ContentValidatorAssociatedKeys.Validators) as? NSArray
        guard let validators = optionalValidators else {
            return []
        }
        return validators as! [Validator]
    }
    
    func addValidator(validator: Validator) {
        addValidators([validator])
    }
    func addValidators(validators: [Validator]) {
        var currentValidators = self.validators
        currentValidators.appendContentsOf(validators)
        objc_setAssociatedObject(self, &ContentValidatorAssociatedKeys.Validators, validators as NSArray?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func validate(showResult: Bool) -> Bool {
        for validator in validators {
            if !validator.validate(getValue()) {
                if showResult {
                    showError(validator.failedMessage!)
                }
                return false
            }
        }
        return true
    }
}