import UIKit

@objc(BPAboutViewControllerDoubleCell)
class AboutDoubleCell: AboutBaseCell {

    private let firstButton = UIButton(type: .custom)
    private let secondButton = UIButton(type: .custom)
    
    override var aboutRowInfo: BPAboutRow? {
        didSet {
            guard let doubleRow = aboutRowInfo as? BPDoubleAboutRow else {
                return
            }
            firstButton.setTitle(doubleRow.title, for: .normal)
            firstButton.addTarget(doubleRow.target, action: doubleRow.action, for: .touchUpInside)
            
            secondButton.setTitle(doubleRow.secondTitle, for: .normal)
            secondButton.addTarget(doubleRow.target, action: doubleRow.action, for: .touchUpInside)
        }
    }
    
    override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        applyStyle(for: firstButton)
        contentView.addSubview(firstButton)
        applyStyle(for: secondButton)
        contentView.addSubview(secondButton)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = CGRect(x: backgroundHorizontalMargin,
                        y: backgroundVerticalMargin,
                        width: (contentView.frame.width - (3 * backgroundHorizontalMargin)) / 2,
                        height: contentView.frame.height - (2 * backgroundVerticalMargin))
        firstButton.frame = frame
        frame.origin.x += frame.maxX
        secondButton.frame = frame
    }

    private func applyStyle(for button: UIButton) {
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.setTitleColor(Theme.defaultTextColor, for: .normal)
        button.titleLabel?.font = Theme.normalFont
    }
}
