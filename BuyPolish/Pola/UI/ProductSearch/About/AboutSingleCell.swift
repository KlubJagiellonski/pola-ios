import UIKit

final class AboutSingleCell: AboutBaseCell {
    private let themeBackgroundView = UIView()

    func configure(rowInfo: AboutRow) {
        textLabel?.text = rowInfo.title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

      themeBackgroundView.backgroundColor = Theme.lightBackgroundColor
        contentView.insertSubview(themeBackgroundView, belowSubview: textLabel!)

        textLabel?.textColor = Theme.defaultTextColor
        textLabel?.font = Theme.normalFont
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        themeBackgroundView.frame = bounds.insetBy(dx: backgroundHorizontalMargin, dy: backgroundVerticalMargin)
        textLabel?.frame = themeBackgroundView.frame.offsetBy(dx: 20.0, dy: .zero)
    }
}
