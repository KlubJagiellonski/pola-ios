import Foundation
import UIKit

typealias ImageUrl = String

enum DropDownValue {
    case Text(String?)
    case Color(UIColor?)
    case Image(ImageUrl?)
}

class DropDownButton : UIControl {
    private let borderWidth: CGFloat = 1
    private let imageMargin: CGFloat = 6
    private let defaultHorizontalMargin: CGFloat = 9
    private let valueArrowHorizontalMargin: CGFloat = 4
    
    let valueImageView = ColorIconView()
    let valueLabel = UILabel()
    let arrowImageView = UIImageView(image: UIImage(asset: .Ic_dropdown))
    
    var value: DropDownValue {
        didSet {
            valueLabel.hidden = true
            valueImageView.hidden = true
            
            switch value {
            case .Text(let text):
                valueLabel.text = text
                valueLabel.hidden = false
            case .Image(let imageUrl):
                valueImageView.image = nil
                valueImageView.hidden = false
                if let url = imageUrl {
                    valueImageView.setColorRepresentation(.ImageUrl(url))
                }
            case .Color(let color):
                valueImageView.hidden = false
                valueImageView.image = nil
                if let c = color {
                    valueImageView.setColorRepresentation(.Color(c))
                }
            }
        }
    }
    
    init(value: DropDownValue = .Text(nil)) {
        self.value = value
        
        super.init(frame: CGRectZero)
        
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = borderWidth
        
        valueLabel.font = UIFont(fontType: .FormNormal)
        valueLabel.textColor = UIColor(named: .Black)
        
        valueImageView.layer.borderWidth = 1
        valueImageView.layer.borderColor = UIColor(named: .Manatee).CGColor
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DropDownButton.didTapView)))
        
        addSubview(valueImageView)
        addSubview(valueLabel)
        addSubview(arrowImageView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView() {
        sendActionsForControlEvents(.TouchUpInside)
    }
    
    private func configureCustomConstraints() {
        valueImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(imageMargin)
            make.top.equalToSuperview().offset(imageMargin)
            make.bottom.equalToSuperview().inset(imageMargin)
            make.width.equalTo(valueImageView.snp_height)
        }
        
        valueLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(defaultHorizontalMargin)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(defaultHorizontalMargin)
            make.centerY.equalToSuperview().offset(2)
        }
    }
}
