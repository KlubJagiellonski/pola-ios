import UIKit

class InAppOnboardingActionAnimator: DropUpActionAnimator {
    init(parentViewHeight: CGFloat) {
        let dropUpTopInset: CGFloat = { _ in
            switch UIDevice.currentDevice().screenType {
            case .iPhone4: return 83.0
            default: return 97.0
            }
        }()
        
        super.init(height: parentViewHeight - dropUpTopInset)
    }
}