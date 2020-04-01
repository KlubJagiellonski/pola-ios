import UIKit

final class AboutFooterView: UIView {
    
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        infoLabel.font = Theme.normalFont
        infoLabel.textColor = Theme.defaultTextColor
        infoLabel.numberOfLines = 3
        let bundle = Bundle.main
        let versionString = "\(bundle.shortVersion) (\(bundle.version))"
        infoLabel.text = R.string.localizable.aboutInfo(versionString)
        addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let horizontalMargin = CGFloat(35.0)
        infoLabel.frame = CGRect(x: horizontalMargin,
                                 y: .zero,
                                 width: bounds.width - (2 * horizontalMargin),
                                 height: bounds.height)
    }
    

}
