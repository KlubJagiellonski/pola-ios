import UIKit

class AboutBaseCell: UITableViewCell {
    let backgroundHorizontalMargin = CGFloat(16.0)
    let backgroundVerticalMargin = CGFloat(8.0)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Theme.mediumBackgroundColor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
