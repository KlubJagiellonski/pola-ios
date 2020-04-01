import UIKit

final class KeyboardTextView: UIView {
    
    private let topView = UIView()
    let codeLabel = UILabel()
    let removeButton = UIButton()
    private let errorView = UIView()
    private let errorLabel = UILabel()
    private let topViewHeight = CGFloat(38.0)
    private let errorViewHeight = CGFloat(27.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cornerRadius = CGFloat(2.0)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        topView.backgroundColor = Theme.clearColor
        topView.layer.cornerRadius = cornerRadius
        topView.layer.masksToBounds = true
        addSubview(topView)
        
        codeLabel.font = Theme.titleFont
        codeLabel.textColor = Theme.defaultTextColor
        codeLabel.text = "1"
        codeLabel.sizeToFit()
        codeLabel.text = nil
        topView.addSubview(codeLabel)
        
        removeButton.accessibilityLabel = R.string.localizable.accessibilityKeyboardDelete()
        removeButton.addTarget(self, action: #selector(tapRemove), for: .touchUpInside)
        removeButton.setImage(R.image.kb_delete(), for: .normal)
        removeButton.setImage(R.image.kb_delete_highlighted(), for: .highlighted)
        removeButton.sizeToFit()
        topView.addSubview(removeButton)
        
        errorView.alpha = 0.0
        errorView.backgroundColor = Theme.lightBackgroundColor
        addSubview(errorView)
        
        errorLabel.text = R.string.localizable.writeCodeError()
        errorLabel.font = Theme.titleFont
        errorLabel.textColor = Theme.defaultTextColor
        errorLabel.sizeToFit()
        errorView.addSubview(errorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widht = bounds.width
        
        topView.frame = CGRect(x: .zero, y: .zero, width: widht, height: topViewHeight)
        
        removeButton.sizeToFit()
        let removeButtonWidth = removeButton.bounds.width + 12.0
        removeButton.frame = CGRect(
            x: widht - removeButtonWidth - 6.0,
            y: .zero,
            width: removeButtonWidth,
            height: topViewHeight
        )
        
        let codeLabelHeight = codeLabel.bounds.height
        codeLabel.frame = CGRect(
            x: 8.0,
            y: (topView.bounds.height / 2.0) - (codeLabelHeight / 2.0),
            width: removeButton.frame.minX - 11.0,
            height: codeLabelHeight
        )
        
        errorView.frame = CGRect(x: .zero, y: topView.frame.maxY, width: widht, height: errorViewHeight)
        
        errorLabel.frameOrigin = CGPoint(
            x: (errorView.bounds.width / 2.0) - (errorLabel.frame.width / 2.0),
            y: (errorView.bounds.height / 2.0) - (errorLabel.frame.height / 2.0)
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: topViewHeight + errorViewHeight)
    }
    
    func insert(value: Int) {
        let currentText = codeLabel.text ?? ""
        guard currentText.count < 13 else {
            return
        }
        
        codeLabel.text = currentText.appending("\(value)")
    }
    
    func showErrorMessage() {
        setHiddenErrorView(false)
    }
    
    func hideErrorMessage() {
        setHiddenErrorView(true)
    }
    
    var code: String? {
        codeLabel.text
    }
    
    private func setHiddenErrorView(_ hidden: Bool) {
        let newAlpha = CGFloat(hidden ? 0.0 : 1.0)
        guard newAlpha != errorView.alpha else {
            return
        }
        UIView.animate(withDuration: 0.2) { [errorView] in
            errorView.alpha = newAlpha
        }
    }
    
    @objc
    private func tapRemove() {
        var text = codeLabel.text ?? ""
        guard text.count > 0 else {
            return
        }
        text.removeLast()
        codeLabel.text = text
    }
}
