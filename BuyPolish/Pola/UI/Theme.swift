import UIKit

@objc(BPTheme)
class Theme: NSObject {
    @objc static let lightBackgroundColor = UIColor(rgb: 0xCCCCCC)
    
    @objc static let actionColor = UIColor(rgb: 0xD8002F)

    @objc static let strongBackgroundColor = UIColor(rgb: 0x666666)

    @objc static let clearColor = UIColor.white
    
    @objc static let defaultTextColor = UIColor(rgb: 0x333333)

    @objc static let mediumBackgroundColor = UIColor(rgb: 0xE9E8E7)

    @objc static let titleFont = R.font.latoRegular(size: 16)

    @objc static let captionFont = R.font.latoLight(size: 12)

    @objc static let normalFont = R.font.latoLight(size: 14)

    @objc static let buttonFont = R.font.latoSemibold(size: 14)
}
