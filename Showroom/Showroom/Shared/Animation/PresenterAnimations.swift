import Foundation
import UIKit

struct DimModalAnimation: PresenterModalAnimation {
    let animationDuration: NSTimeInterval
    
    func showModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        modalView.alpha = 0.0
        UIView.animateWithDuration(animationDuration, animations: {
            modalView.alpha = 1.0
            }, completion: completion)
    }
    
    func hideModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        modalView.alpha = 1.0
        UIView.animateWithDuration(animationDuration, animations: {
            modalView.alpha = 0.0
        }, completion: completion)
    }
}

protocol ImageAnimationTargetViewInterface: class {
    var viewsAboveImageVisibility: Bool { get set }
    var highResImage: UIImage? { get }
    var highResImageVisible: Bool { get set }
}

struct ImageAnimation: PresenterModalAnimation {
    private let mainAnimationRelativeTime = 0.6
    
    let animationDuration: NSTimeInterval
    let imageView: UIImageView
    let alternativeAnimation: PresenterModalAnimation
    
    func showModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        guard let animationTargetModalView = modalView as? ImageAnimationTargetViewInterface else {
            fatalError("modalView should conforms to protocol ImageAnimationTargetViewInterface")
        }
        
        let ratio = imageView.bounds.width / imageView.bounds.height
        let initialFrame = imageView.superview!.convertRect(imageView.frame, toView: containerView)
        let finalFrame = CGRectMake(0, 0, containerView.bounds.width, containerView.bounds.width / ratio)
        
        let movingImageView = UIImageView(image: imageView.image)
        movingImageView.frame = initialFrame
        
        let scaleFactor = containerView.bounds.width / movingImageView.bounds.width
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        imageView.alpha = 0
        modalView.alpha = 0
        animationTargetModalView.viewsAboveImageVisibility = false
        animationTargetModalView.highResImageVisible = false
        containerView.addSubview(movingImageView)
        
        let mainAnimationTime = animationDuration * mainAnimationRelativeTime
        let endAnimationTime = animationDuration - mainAnimationTime
        
        UIView.animateKeyframesWithDuration(mainAnimationTime, delay: 0, options: [], animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1.0) {
                movingImageView.transform = scaleTransform
                movingImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.6) {
                modalView.alpha = 1
            }
        }) { success in
            self.imageView.alpha = 1
            animationTargetModalView.highResImageVisible = true
            movingImageView.removeFromSuperview()
            UIView.animateWithDuration(endAnimationTime, animations: {
                animationTargetModalView.viewsAboveImageVisibility = true
                }, completion: completion)
        }
        
    }
    
    func hideModal(containerView: ContainerView, contentView: ContentView?, modalView: ModalView, completion: ((Bool) -> ())?) {
        guard let animationTargetModalView = modalView as? ImageAnimationTargetViewInterface else {
            fatalError("modalView should conforms to protocol ImageAnimationTargetViewInterface")
        }
        guard let targetImage = animationTargetModalView.highResImage else {
            alternativeAnimation.hideModal(containerView, contentView: contentView, modalView: modalView, completion: completion)
            return
        }
        
        let ratio = imageView.bounds.width / imageView.bounds.height
        let initialFrame = CGRectMake(0, 0, containerView.bounds.width, containerView.bounds.width / ratio)
        let finalFrame = imageView.superview!.convertRect(imageView.frame, toView: containerView)
        
        let movingImageView = UIImageView(image: targetImage)
        movingImageView.frame = initialFrame
        
        let scaleFactor = imageView.bounds.width / containerView.bounds.width
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        animationTargetModalView.viewsAboveImageVisibility = true
        imageView.alpha = 0
        modalView.alpha = 1
        movingImageView.alpha = 0
        animationTargetModalView.highResImageVisible = true
        containerView.addSubview(movingImageView)
        
        let mainAnimationTime = animationDuration * mainAnimationRelativeTime
        let startAnimationTime = animationDuration - mainAnimationTime
        
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
                    modalView.alpha = 0
                }
            }) { success in
                self.imageView.alpha = 1
                movingImageView.removeFromSuperview()
                completion?(success)
            }
        }
    }
}