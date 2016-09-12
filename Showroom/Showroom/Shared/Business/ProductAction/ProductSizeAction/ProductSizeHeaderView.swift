import Foundation
import UIKit

class ProductSizeHeaderView: UIView {
    private let headerHeight: CGFloat = 31
    private let separatorHeight: CGFloat = 1
    
    private let label = UILabel()
    let button = UIButton()
    
    private let separatorView = UIView()
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .Snow)
        
        label.text = tr(.ProductActionPickSizeTitleFirstPart)
        label.font = UIFont(fontType: .ProductActionHeader)
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        
        button.setTitle(tr(.ProductActionPickSizeTitleSecondPart), forState: .Normal)
        button.applySimpleBlueStyle()
        addSubview(button)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(separatorHeight)
        }
        
        label.snp_makeConstraints { make in
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalTo(button.snp_leading)
            make.bottom.equalTo(separatorView.snp_top)
            make.top.equalToSuperview()
        }
        
        button.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalTo(separatorView.snp_top)
            make.top.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(0, headerHeight)
    }
}