import Foundation
import UIKit

protocol ImageAnimationTargetViewInterface: class {
    var viewsAboveImageVisibility: Bool { get set }
    var highResImage: UIImage? { get }
    var highResImageVisible: Bool { get set }
}

final class ImageTransitionAnimation: TransitionAnimation {
    private let mainAnimationRelativeTime = 0.6
    
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
        guard let animationTargetModalView = presentedView as? ImageAnimationTargetViewInterface else {
            fatalError("modalView should conforms to protocol ImageAnimationTargetViewInterface")
        }
        
        let finalImageView = imageView
        
        let ratio = finalImageView.bounds.width / finalImageView.bounds.height
        let initialFrame = finalImageView.superview!.convertRect(finalImageView.frame, toView: containerView)
        let finalFrame = CGRectMake(0, 0, containerView.bounds.width, containerView.bounds.width / ratio)
        
        logInfo("Animating image from \(initialFrame) to \(finalFrame)")
        
        let movingImageView = UIImageView(image: finalImageView.image)
        movingImageView.frame = initialFrame
        
        let scaleFactor = containerView.bounds.width / movingImageView.bounds.width
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        finalImageView.alpha = 0
        presentedView.alpha = 0
        animationTargetModalView.viewsAboveImageVisibility = false
        animationTargetModalView.highResImageVisible = false
        containerView.addSubview(movingImageView)
        
        let mainAnimationTime = animationDuration * mainAnimationRelativeTime
        let endAnimationTime = animationDuration - mainAnimationTime
        
        UIView.animateWithDuration(mainAnimationTime + endAnimationTime) { [unowned self] in
            self.additionalAnimationBlock?()
        }
        
        UIView.animateKeyframesWithDuration(mainAnimationTime, delay: 0, options: [], animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1.0) {
                movingImageView.transform = scaleTransform
                movingImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.6) {
                presentedView.alpha = 1
            }
        }) { success in
            finalImageView.alpha = 1
            animationTargetModalView.highResImageVisible = true
            movingImageView.removeFromSuperview()
            UIView.animateWithDuration(endAnimationTime, animations: {
                animationTargetModalView.viewsAboveImageVisibility = true
                }, completion: completion)
        }

    }
    
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?) {
        logInfo("Hiding image")
        guard let animationTargetModalView = presentedView as? ImageAnimationTargetViewInterface else {
            fatalError("modalView should conforms to protocol ImageAnimationTargetViewInterface")
        }
        guard let targetImage = animationTargetModalView.highResImage else {
            alternativeAnimation.additionalAnimationBlock = additionalAnimationBlock
            alternativeAnimation.hide(containerView, presentedView: presentedView, presentationView: presentationView, completion: completion)
            return
        }
        
        let finalImageView = self.imageView
        
        let ratio = finalImageView.bounds.width / finalImageView.bounds.height
        let initialFrame = CGRectMake(0, 0, containerView.bounds.width, containerView.bounds.width / ratio)
        let finalFrame = finalImageView.superview!.convertRect(finalImageView.frame, toView: containerView)
        
        logInfo("Animating image from \(initialFrame) to \(finalFrame)")
        
        let movingImageView = UIImageView(image: targetImage)
        movingImageView.frame = initialFrame
        
        let scaleFactor = finalImageView.bounds.width / containerView.bounds.width
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        animationTargetModalView.viewsAboveImageVisibility = true
        finalImageView.alpha = 0
        presentedView.alpha = 1
        movingImageView.alpha = 0
        animationTargetModalView.highResImageVisible = true
        containerView.addSubview(movingImageView)
        
        let mainAnimationTime = animationDuration * mainAnimationRelativeTime
        let startAnimationTime = animationDuration - mainAnimationTime
        
        UIView.animateWithDuration(startAnimationTime + mainAnimationTime) { [unowned self] in
            self.additionalAnimationBlock?()
        }
        
        UIView.animateWithDuration(startAnimationTime, animations: {
            animationTargetModalView.viewsAboveImageVisibility = false
        }) { success in
            movingImageView.alpha = 1
            animationTargetModalView.highResImageVisible = false
            UIView.animateKeyframesWithDuration(mainAnimationTime, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0) {
                    movingImageView.transform = scaleTransform
                    movingImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                }
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.6) {
                    presentedView.alpha = 0
                }
            }) { success in
                finalImageView.alpha = 1
                movingImageView.removeFromSuperview()
                completion?(success)
            }
        }
    }
}