import Foundation

protocol SlideshowImageAnimationTargetViewInterface: class {
    var transitionAnimationInProgress: Bool { get set }
    var viewsAboveImageVisibility: Bool { get set }
    
    func addTransitionView(view: UIView)
}

final class SlideshowImageTransitionAnimation: TransitionAnimation {
    let animationDuration: NSTimeInterval
    let imageView: UIImageView
    var alternativeAnimation: TransitionAnimation
    
    var additionalAnimationBlock: (Void -> Void)?
    
    init(animationDuration: NSTimeInterval, imageView: UIImageView, alternativeAnimation: TransitionAnimation) {
        self.animationDuration = animationDuration
        self.imageView = imageView
        self.alternativeAnimation = alternativeAnimation
    }
    
    func show(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        logInfo("Showing image")
        
        guard let animationTargetModalView = presentedView as? SlideshowImageAnimationTargetViewInterface else {
            fatalError("modalView should conforms to protocol ImageAnimationTargetViewInterface")
        }
        
        let finalImageView = imageView
        
        let initialFrame = finalImageView.superview!.convertRect(finalImageView.frame, toView: containerView)
        let finalFrame = CGRectMake(0, 0, containerView.bounds.width, containerView.bounds.height)
        
        logInfo("Animating image from \(initialFrame) to \(finalFrame)")
        
        let movingImageView = createImageView(fromImageView: finalImageView)
        movingImageView.frame = initialFrame
        
        let scaleFactor = containerView.bounds.height / movingImageView.bounds.height
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        finalImageView.alpha = 0
        presentedView.alpha = 0
        animationTargetModalView.viewsAboveImageVisibility = false
        containerView.addSubview(movingImageView)
        
        animationTargetModalView.transitionAnimationInProgress = true
        
        UIView.animateWithDuration(animationDuration) { [unowned self] in
            self.additionalAnimationBlock?()
        }
        
        let transitionImageView = createImageView(fromImageView: movingImageView)
        
        UIView.animateWithDuration(animationDuration, animations: {
            movingImageView.transform = scaleTransform
            movingImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { success in
            finalImageView.alpha = 1
            presentedView.alpha = 1
            movingImageView.removeFromSuperview()
            
            animationTargetModalView.addTransitionView(transitionImageView)
            animationTargetModalView.transitionAnimationInProgress = false
            
            UIView.animateWithDuration(0.2) {
                animationTargetModalView.viewsAboveImageVisibility = true
            }
            
            completion?(success)
        }
    }
    
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        fatalError("Hidding not supported")
    }
    
    private func createImageView(fromImageView imageView: UIImageView) -> UIImageView {
        let imageView = UIImageView(image: imageView.image)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }
}
