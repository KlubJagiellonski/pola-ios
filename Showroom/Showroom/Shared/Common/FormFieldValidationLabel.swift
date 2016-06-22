import UIKit

class FormFieldValidationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont(fontType: .Description)
        textColor = UIColor(named: .White)
        backgroundColor = UIColor(named: .Black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 5)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}