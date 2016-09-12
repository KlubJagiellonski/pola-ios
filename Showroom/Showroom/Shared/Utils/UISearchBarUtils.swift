import UIKit

extension UISearchBar {
    func applyDefaultStyle() {
        backgroundImage = UIImage.fromColor(UIColor.clearColor())
        setSearchFieldBackgroundImage(UIImage.fromColor(UIColor(named: .Mercury), size: CGSizeMake(28, 28)).round(withCornerRadius: 5), forState: .Normal)
        searchTextPositionAdjustment = UIOffsetMake(8, 0)
        setPositionAdjustment(UIOffsetMake(4, 0), forSearchBarIcon: .Search)
    }
}