import Foundation
import UIKit

struct Dimensions {
    static let defaultMargin: CGFloat = 15
    static let defaultButtonHeight: CGFloat = 37
    static let defaultInputHeight: CGFloat = 26
    static let defaultSeparatorThickness: CGFloat = 0.5 // should be 1 for non-retina devices only
    static let boldSeparatorThickness: CGFloat = 1.0
    static let defaultCellHeight: CGFloat = 44
    static let tabViewHeight: CGFloat = 49 // May by useful when bottomLayooutGuide is not available
    static let navigationBarHeight: CGFloat = 44 // May by useful when topLayoutGuide is not available
    static let statusBarHeight: CGFloat = 20 // May by useful when topLayoutGuide is not available
    static let recommendationItemSize = CGSizeMake(118, 223)
    static let defaultImageRatio = 0.7776
    static let circleButtonDiameter: CGFloat = 38
    static let bigCircleButtonDiameter: CGFloat = 52
    static let modalTopMargin: CGFloat = 24
    static let bigButtonHeight: CGFloat = 52
    static let topBadgeSize = CGSizeMake(31, 15)
    static let bottomBadgeHeight: CGFloat = 15
    static let onboardingTextHorizontalOffset: CGFloat = 22
    static let contentPromoImageWidth: CGFloat = UIScreen.mainScreen().bounds.width
}