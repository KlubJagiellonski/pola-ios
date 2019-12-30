import UIKit

@objc(BPAboutViewControllerBaseCell)
class AboutBaseCell: UITableViewCell {
    let backgroundHorizontalMargin = CGFloat(16.0)
    let backgroundVerticalMargin = CGFloat(8.0)

    @objc
    weak var aboutRowInfo: BPAboutRow?

    @objc
    init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Theme.mediumBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
