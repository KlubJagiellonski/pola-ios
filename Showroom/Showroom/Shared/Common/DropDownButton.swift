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
    private let defaultMargin: CGFloat = 5
    private let valueArrowHorizontalMargin: CGFloat = 4
    
    private let valueImageView: ColorIconView?
    private let valueLabel: UILabel?
    private let arrowImageView = UIImageView(image: UIImage(asset: .Ic_dropdown))
    
    var value: DropDownValue {
        didSet {
            switch value {
            case .Text(let text):
                guard let valueLabel = valueLabel else {
                    fatalError("Cannot change dropdown type after initialization \(oldValue) \(value)")
                }
                valueLabel.text = text ?? ""
            case .Image(let imageUrl):
                guard let valueImageView = valueImageView else {
                    fatalError("Cannot change dropdown type after initialization \(oldValue) \(value)")
                }
                valueImageView.image = nil
                if let url = imageUrl {
                    valueImageView.setColorRepresentation(.ImageUrl(url))
                }
            case .Color(let color):
                guard let valueImageView = valueImageView else {
                    fatalError("Cannot change dropdown type after initialization \(oldValue) \(value)")
                }
                valueImageView.image = nil
                if let c = color {
                    valueImageView.setColorRepresentation(.Color(c))
                } else {
                    valueImageView.setColorRepresentation(.None)
                }
            }
        }
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                layer.borderColor = UIColor(named: .Black).CGColor
                arrowImageView.image = UIImage(asset: .Ic_dropdown)
            } else {
                layer.borderColor = UIColor(named: .DarkGray).CGColor
                arrowImageView.image = UIImage(asset: .Ic_dropdown_disabled)
            }
        }
    }
    
    init(value: DropDownValue = .Text(nil)) {
        self.value = value
        
        switch value {
        case .Text:
            let valueLabel = UILabel()
            valueLabel.font = UIFont(fontType: .FormNormal)
            valueLabel.textColor = UIColor(named: .Black)
            valueLabel.textAlignment = .Center
            self.valueLabel = valueLabel
            self.valueImageView = nil
        case .Image, .Color:
            let valueImageView = ColorIconView()
            valueImageView.layer.borderWidth = 1
            valueImageView.layer.borderColor = UIColor(named: .Manatee).CGColor
            self.valueImageView = valueImageView
            self.valueLabel = nil
        }
        
        super.init(frame: CGRectZero)
        
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = borderWidth
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DropDownButton.didTapView)))
        
        switch value {
        case .Text:
            addSubview(valueLabel!)
            
            valueLabel!.snp_makeConstraints { make in
                make.leading.equalToSuperview().offset(defaultMargin)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-23)
            }
        case .Image, .Color:
            addSubview(valueImageView!)
            valueImageView!.snp_makeConstraints { make in
                make.leading.equalToSuperview().offset(defaultMargin)
                make.top.equalToSuperview().offset(defaultMargin)
                make.bottom.equalToSuperview().inset(defaultMargin)
                make.width.equalTo(valueImageView!.snp_height)
            }
        }
        
        addSubview(arrowImageView)
        
        arrowImageView.snp_makeConstraints { make in
            make.trailing.equalToSuperview().inset(defaultMargin)
            make.centerY.equalToSuperview().offset(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapView() {
        sendActionsForControlEvents(.TouchUpInside)
    }
}
