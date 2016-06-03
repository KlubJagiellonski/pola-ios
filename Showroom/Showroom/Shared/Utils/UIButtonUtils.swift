import Foundation
import UIKit

extension UIButton {
    func applyBlueStyle() {
        backgroundColor = UIColor(named: .Blue)
        titleLabel!.font = UIFont(fontType: .Button)
    }
    
    func applyPlainStyle() {
        setTitleColor(UIColor(named: .Blue), forState: .Normal)
        titleLabel!.font = UIFont(fontType: .List)
    }
    
    func applyDropDownStyle() {
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        titleLabel!.font = UIFont(fontType: .FormNormal)
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1;
        contentEdgeInsets = UIEdgeInsetsMake(4, 6, 5, 9)
        setImage(UIImage(asset: Asset.Ic_dropdown_small), forState: .Normal)
        semanticContentAttribute = .ForceRightToLeft
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8)
    }
    
    func applyCircleStyle() {
        layer.cornerRadius = Dimensions.circleButtonDiameter * 0.5
        backgroundColor = UIColor(named: .White)
    }
    
    func applySimpleBlueStyle() {
        setTitleColor(UIColor(named: .Blue), forState: .Normal)
        titleLabel?.font = UIFont(fontType: .ProductActionHeader)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.lineBreakMode = .ByClipping
    }
}