import Foundation
import UIKit

struct ProgressInfoState {
    let currentStep: Int
    let currentStepProgress: Double
}

final class PromoSlideshowProgressView: UIView {
    private var progressViews: [UIView] = []
    
    init() {
        super.init(frame: CGRectZero)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with video: PromoSlideshowVideo) {
        
    }
    
    func update(with progress: ProgressInfoState) {
        
    }
}

final class PromoSlideshowStepProgressView: UIView {
    
}