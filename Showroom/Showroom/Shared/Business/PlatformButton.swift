import UIKit

class PlatformButton: UIButton {
    
    private let flagAndText = UIImageView()
    
    init(flagAndTextImage: UIImage) {
        super.init(frame: CGRectZero)
        
        setBackgroundImage(UIImage.fromColor(UIColor(named: .White)), forState: .Normal)
        
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.borderWidth = 2
        
        flagAndText.image = flagAndTextImage
        
        addSubview(flagAndText)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        flagAndText.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}