import UIKit

class PlatformButton: UIButton {
    
    private let flag = UIImageView()
    private let label = UILabel()
    
    init(flagImage: UIImage, title: String) {
        super.init(frame: CGRectZero)
        
        setBackgroundImage(UIImage.fromColor(UIColor(named: .White)), forState: .Normal)
        
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.borderWidth = 2
        
        flag.image = flagImage
        
        label.text = title
        label.textColor = UIColor(named: .Black)
        label.font = UIFont(fontType: .NormalBold)
        
        addSubview(flag)
        addSubview(label)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        flag.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        label.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
    
}