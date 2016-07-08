import Foundation
import UIKit

extension UIButton {
    var title: String? {
        set {
            setTitle(newValue, forState: .Normal)
        }
        
        get {
            return titleLabel?.text
        }
    }
    
    func applyBlueStyle() {
        titleLabel!.font = UIFont(fontType: .Button)
        setTitleColor(UIColor(named: .White), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .Blue)), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .DarkGray)), forState: .Disabled)
    }
    
    func applyPlainStyle() {
        setTitleColor(UIColor(named: .Blue), forState: .Normal)
        setTitleColor(UIColor(named: .Black), forState: .Highlighted)
        setTitleColor(UIColor(named: .DarkGray), forState: .Disabled)
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
    
    func applyBigCircleStyle() {
        layer.cornerRadius = Dimensions.bigCircleButtonDiameter * 0.5
        backgroundColor = UIColor(named: .White)
    }
    
    func applySimpleBlueStyle() {
        setTitleColor(UIColor(named: .Blue), forState: .Normal)
        titleLabel?.font = UIFont(fontType: .ProductActionHeader)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.lineBreakMode = .ByClipping
    }
    
    func applyFacebookStyle() {
        titleLabel!.font = UIFont(fontType: .Button)
        setTitleColor(UIColor(named: .White), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .Facebook)), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .DarkGray)), forState: .Disabled)
        setImage(UIImage(asset: Asset.Ic_fb), forState: .Normal)
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, Dimensions.defaultMargin)
    }
    
    func applyLoginStyle() {
        titleLabel!.font = UIFont(fontType: .NormalBold)
        setTitleColor(UIColor(named: .Blue), forState: .Normal)
    }
    
    func applyGhostStyle() {
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.borderWidth = 2;
        setTitleColor(UIColor(named: .Black), forState: .Normal)
        setTitleColor(UIColor(named: .White), forState: .Highlighted)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .White)), forState: .Normal)
        setBackgroundImage(UIImage.fromColor(UIColor(named: .Blue)), forState: .Highlighted)
        titleLabel!.font = UIFont(fontType: .GhostButton)
    }
}