import Foundation
import UIKit
import SnapKit

class TitleValueLabel: UIView {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    private let leading: CGFloat = -2
    
    var title: String? {
        get {
            return titleLabel.text
        }
        
        set {
            titleLabel.text = newValue
        }
    }
    
    var value: String? {
        get {
            return valueLabel.text
        }
        
        set {
            valueLabel.text = newValue
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        titleLabel.text = "Title"
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont(fontType: .List)
        
        valueLabel.textColor = UIColor(named: .DarkGray)
        valueLabel.font = UIFont(fontType: .List)
        
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        valueLabel.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp_bottom).offset(leading)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let keyHeight = titleLabel.intrinsicContentSize().height
        let valueHeight = valueLabel.intrinsicContentSize().height
        return CGSizeMake(0, keyHeight + leading + valueHeight)
    }
}
