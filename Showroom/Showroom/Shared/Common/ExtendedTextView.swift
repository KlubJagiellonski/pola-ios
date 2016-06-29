import Foundation
import UIKit

class ExtendedTextView: UITextView {
    private let placeholderLabel = UILabel()
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
    }
    
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        
        set {
            placeholderLabel.text = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExtendedTextView.textDidChange), name: UITextViewTextDidChangeNotification, object: self)
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor(named: .DarkGray)
        placeholderLabel.numberOfLines = 0
        
        insertSubview(placeholderLabel, atIndex: 0)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func configureCustomConstraints() {
        placeholderLabel.snp_makeConstraints { make in
            make.left.equalTo(textInputView).inset(textContainerInset.left + 5)
            make.top.equalTo(textInputView).inset(textContainerInset.top)
            make.right.equalTo(textInputView).inset(textContainerInset.right + 5).priorityHigh()
        }
    }
    
    @objc private func textDidChange(notification: NSNotification) {
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.hidden = text?.characters.count > 0
    }
}
