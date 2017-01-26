import Foundation
import UIKit

extension UIFont {
    enum FontType: String {
        case Bold
        case Italic
        case Normal
        case NormalBold
        case FormNormal
        case PriceNormal
        case PriceBold
        case PriceList
        case PriceSmall
        case TabBar
        case Description
        case List
        case Button
        case GhostButton
        case FormBold
        case ErrorBold
        case ProductListBoldText
        case ProductListName
        case ProductListText
        case Badge
        case TabBarBadge
        case Input
        case InputLarge
        case ProductActionHeader
        case ProductActionOption
        case CheckoutSummary
        case NavigationBar
        case Onboarding
        case NavigationBarButton
    }
        
    convenience init!(fontType: FontType) {
        switch fontType {
        case .Bold:
            self.init(name: "Lato-Heavy", size: 18)
        case .Italic:
            self.init(name: "Georgia-Italic", size: 16)
        case .Normal:
            self.init(name: "Lato-Regular", size: 14)
        case .NormalBold:
            self.init(name: "Lato-Bold", size: 14)
        case .FormNormal:
            self.init(name: "Lato-Semibold", size: 14)
        case .PriceNormal:
            self.init(name: "Lato-Regular", size: 20)
        case .PriceBold:
            self.init(name: "Lato-Heavy", size: 18)
        case .PriceList:
            self.init(name: "Lato-Regular", size: 13)
        case .PriceSmall:
            self.init(name: "Lato-Regular", size: 10)
        case .TabBar:
            self.init(name: "Lato-Regular", size: 10)
        case .Description:
            self.init(name: "Lato-Regular", size: 13)
        case .List:
            self.init(name: "Lato-Regular", size: 13)
        case .Button:
            self.init(name: "Lato-Bold", size: 16)
        case .GhostButton:
            self.init(name: "Lato-Bold", size: 12)
        case .FormBold:
            self.init(name: "Lato-Heavy", size: 14)
        case .ErrorBold:
            self.init(name: "Lato-Heavy", size: 13)
        case .ProductListBoldText:
            self.init(name: "Lato-Heavy", size: 11)
        case .ProductListName:
            self.init(name: "Lato-Regular", size: 12)
        case .ProductListText:
            self.init(name: "Lato-Regular", size: 11)
        case .Badge:
            self.init(name: "Lato-Regular", size: 10)
        case .TabBarBadge:
            self.init(name: "Lato-Regular", size: 13)
        case .Input:
            self.init(name: "Lato-Regular", size: 13)
        case .InputLarge:
            self.init(name: "Lato-Semibold", size: 14)
        case .ProductActionHeader:
            self.init(name: "Lato-Semibold", size: 11)
        case .ProductActionOption:
            self.init(name: "Lato-Semibold", size: 12)
        case .CheckoutSummary:
            self.init(name: "Lato-Regular", size: 11)
        case .NavigationBar:
            self.init(name: "Lato-Semibold", size: 17)
        case .Onboarding:
            self.init(name: "Lato-Regular", size: 16)
        case .NavigationBarButton:
            self.init(name: "Lato-Semibold", size: 16)
        }
    }
    
    class func latoRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }
    
    class func latoSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Semibold", size: size)!
    }
    
    class func latoBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size)!
    }
    
    class func latoHeavy(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Heavy", size: size)!
    }
    
    class func georgiaItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Georgia-Italic", size: size)!
    }
}
