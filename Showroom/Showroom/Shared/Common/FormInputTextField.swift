import UIKit

final class FormInputTextField: UITextField {
    static let textFieldHeight: CGFloat = 41
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(fontType: .FormNormal)
        self.textAlignment = .Left
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 13, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 13, 0)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, FormInputTextField.textFieldHeight)
    }
}