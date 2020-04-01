import UIKit

final class AboutSingleCell: AboutBaseCell {
    private let whiteBackgroundView = UIView()
    
    func configure(rowInfo: AboutRow) {
        textLabel?.text = rowInfo.title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        whiteBackgroundView.backgroundColor = .white
        contentView.insertSubview(whiteBackgroundView, belowSubview: textLabel!)
        
        textLabel?.textColor = Theme.defaultTextColor
        textLabel?.font = Theme.normalFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        whiteBackgroundView.frame = bounds.insetBy(dx: backgroundHorizontalMargin, dy: backgroundVerticalMargin)
        textLabel?.frame = whiteBackgroundView.frame.offsetBy(dx: 20.0, dy: .zero)
    }
    
}
