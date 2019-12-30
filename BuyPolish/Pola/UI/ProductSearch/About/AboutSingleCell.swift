import UIKit

@objc(BPAboutViewControllerSingleCell)
class AboutSingleCell: AboutBaseCell {
    private let whiteBackgroundView = UIView()
    
    override var aboutRowInfo: BPAboutRow? {
        didSet {
            textLabel?.text = aboutRowInfo?.title
        }
    }
    
    override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        
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
