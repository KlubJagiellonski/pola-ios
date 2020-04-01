import UIKit

final class AltResultContentView: UIView {

    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.font = Theme.normalFont
        textLabel.textColor = Theme.defaultTextColor
        textLabel.numberOfLines = 0
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = CGRect(origin: .zero,
                                 size: sizeThatFits(frame.size))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: textLabel.height(forWidth: size.width))
    }
    
}
