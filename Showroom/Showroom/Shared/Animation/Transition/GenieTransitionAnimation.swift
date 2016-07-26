import Foundation

struct GenieTransitionAnimation: TransitionAnimation {
    let animationDuration: NSTimeInterval
    let destinationRect: CGRect
    
    func show(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        fatalError("Showing with genie animation not supported")
    }
    
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        presentedView.genieInTransitionWithDuration(animationDuration, destinationRect: destinationRect, destinationEdge: .Top) { _ in
            completion?(true)
        }
    }
}