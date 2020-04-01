import UIKit

final class AboutDoubleCell: AboutBaseCell {
    
    enum Segment: Int {
        case first
        case second
        case none
    }

    private let firstButton = UIButton(type: .custom)
    private let secondButton = UIButton(type: .custom)
    
    var selectedSegment = Segment.none

    func configure(rowInfo: DoubleAboutRow) {
        firstButton.setTitle(rowInfo.0.title, for: .normal)
        secondButton.setTitle(rowInfo.1.title, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitted = super.hitTest(point, with: event)
        if hitted == firstButton {
            selectedSegment = .first
        } else if hitted == secondButton {
            selectedSegment = .second
        } else {
            selectedSegment = .none
        }
        return self
    }

    private func applyStyle(for button: UIButton) {
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.setTitleColor(Theme.defaultTextColor, for: .normal)
        button.titleLabel?.font = Theme.normalFont
    }
}
