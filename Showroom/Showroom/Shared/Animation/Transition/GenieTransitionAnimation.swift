import Foundation

final class GenieTransitionAnimation: TransitionAnimation {
    let animationDuration: NSTimeInterval
    let destinationRect: CGRect
    
    var additionalAnimationBlock: (Void -> Void)?
    
    init(animationDuration: NSTimeInterval, destinationRect: CGRect) {
        self.animationDuration = animationDuration
        self.destinationRect = destinationRect
    }
    
    func show(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        fatalError("Showing with genie animation not supported")
    }
    
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        logInfo("Hiding with genie animation")
        UIView.animateWithDuration(animationDuration) { [weak self] _ in
            self?.additionalAnimationBlock?()
        }
        presentedView.genieInTransitionWithDuration(animationDuration, destinationRect: destinationRect, destinationEdge: .Top) { _ in
            completion?(true)
        }
    }
}