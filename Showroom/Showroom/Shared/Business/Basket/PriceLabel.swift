import Foundation
import UIKit

class PriceLabel: UIView {
    
    let normalPriceLabel = UILabel()
    let strikedPriceLabel = UILabel()
    private let leading: CGFloat = -2
    
    var basePrice: Money = Money(amt: 0.0) {
        didSet {
            normalPriceLabel.text = basePrice.stringValue
        }
    }
    
    var discountPrice: Money? = nil {
        didSet {
            if discountPrice == nil {
                strikedPriceLabel.text = nil
            } else {
                strikedPriceLabel.attributedText = basePrice.stringValue.createStrikethroughString(UIColor(named: .DarkGray))
                normalPriceLabel.text = discountPrice?.stringValue
            }
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return normalPriceLabel.textAlignment
        }
        
        set {
            normalPriceLabel.textAlignment = newValue
            strikedPriceLabel.textAlignment = newValue
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        strikedPriceLabel.textColor = UIColor(named: .DarkGray)
        strikedPriceLabel.font = UIFont(fontType: .PriceSmall)
        
        normalPriceLabel.text = "0,00 zł"
        normalPriceLabel.textColor = UIColor.blackColor()
        normalPriceLabel.font = UIFont(fontType: .PriceList)
        
        self.addSubview(normalPriceLabel)
        self.addSubview(strikedPriceLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        strikedPriceLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        normalPriceLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(strikedPriceLabel.snp_bottom).offset(leading)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let keyHeight = normalPriceLabel.intrinsicContentSize().height
        let valueHeight = strikedPriceLabel.intrinsicContentSize().height
        return CGSizeMake(0, keyHeight + valueHeight)
    }
}
