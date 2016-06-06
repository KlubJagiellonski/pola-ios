import Foundation
import UIKit

extension UIFont {
    enum FontType: String {
        case Bold
        case Italic
        case Normal
        case FormNormal
        case PriceNormal
        case PriceList
        case PriceSmall
        case TabBar
        case Description
        case List
        case Button
        case FormBold
        case RecommendedBrand
        case Recommended
        case Badge
        case Input
    }
    
    convenience init!(fontType: FontType) {
        switch fontType {
        case .Bold:
            self.init(name: "Lato-Heavy", size: 18)
        case .Italic:
            self.init(name: "Georgia-Italic", size: 16)
        case .Normal:
            self.init(name: "Lato-Regular", size: 14)
        case .FormNormal:
            self.init(name: "Lato-Semibold", size: 14)
        case .PriceNormal:
            self.init(name: "Lato-Regular", size: 20)
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
        case .FormBold:
            self.init(name: "Lato-Heavy", size: 14)
        case .RecommendedBrand:
            self.init(name: "Lato-Heavy", size: 11)
        case .Recommended:
            self.init(name: "Lato-Regular", size: 11)
        case .Badge:
            self.init(name: "Lato-Regular", size: 10)
        case .Input:
            self.init(name: "Lato-Regular", size: 13)
        }
    }
}
