import Foundation
import UIKit

class FormSheetAnimator: NSObject, UIViewControllerTransitioningDelegate, Animator {
    private let formSize: CGSize?
    
    weak var delegate: DimAnimatorDelegate?
    
    init(formSize: CGSize? = nil) {
        self.formSize = formSize
        super.init()
    }
    
    func presentViewController(presentedViewController: UIViewController, presentingViewController: UIViewController, completion: (() -> Void)? = nil) {
        presentedViewController.modalPresentationStyle = .Custom
        presentedViewController.transitioningDelegate = self
        
        presentingViewController.presentViewController(presentedViewController, animated: true, completion: completion)
    }
    
    func dismissViewController(presentingViewController presentingViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        presentingViewController.dismissViewControllerAnimated(true, completion: completion)
    }
    
    func didTapDimView(sender: UITapGestureRecognizer) {
        delegate?.animatorDidTapOnDimView(self)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FormSheetAnimatedTransitioning(formSize: formSize ?? presented.preferredContentSize, presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FormSheetAnimatedTransitioning(formSize: formSize ?? dismissed.preferredContentSize, presenting: false)
    }
}

class FormSheetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let formSize: CGSize
    private let transitionDuration = 0.2
    let dimViewAlpha: CGFloat = 0.7
    let dimViewColor = UIColor(named: .Dim)
    private let presenting: Bool
    private let dimViewTag = "FORM_SHEET_DIM_VIEW_TAG".hash
    
    init(formSize: CGSize, presenting: Bool) {
        self.formSize = formSize
        self.presenting = presenting
        super.init()
    }
    
    func presentView(presentedView: UIView, presentingView: UIView, dimView: UIView, animationDuration: Double, containerView: UIView, completion: ((completed: Bool) -> Void)?) {
        let initialFrame = calculateInitialFrame(containerView.bounds)
        let finalFrame = calculateFinalFrame(containerView.bounds)
        let scaleFactor = initialFrame.width / finalFrame.width
        
        presentedView.frame = finalFrame
        
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        presentedView.transform = scaleTransform
        presentedView.center = CGPoint(x: CGRectGetMidX(initialFrame), y: CGRectGetMidY(initialFrame))
        presentedView.clipsToBounds = true
        
        dimView.alpha = 0
        presentedView.alpha = 0
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
            presentedView.transform = CGAffineTransformIdentity
            presentedView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            presentedView.alpha = 1
            dimView.alpha = self.dimViewAlpha
            }, completion: { finished in
            completion?(completed: finished)
        })
    }
    
    func dismissView(presentedView: UIView, presentingView: UIView, dimView: UIView, animationDuration: Double, containerView: UIView, completion: ((completed: Bool) -> Void)?) {
        let initialFrame = calculateFinalFrame(containerView.bounds)
        let finalFrame = calculateInitialFrame(containerView.bounds)
        let scaleFactor = finalFrame.width / initialFrame.width
        let scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseIn], animations: {
            presentedView.transform = scaleTransform
            presentedView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            presentedView.alpha = 0
            dimView.alpha = 0
            }, completion: { finished in
                completion?(completed: finished)
        })
    }
    
    func calculateInitialFrame(containerBounds: CGRect) -> CGRect {
        let scale: CGFloat = 1.2
        let width = formSize.width * scale
        let height = formSize.height * scale
        return CGRectMake(ceil(CGRectGetMidX(containerBounds) - width / 2), ceil(CGRectGetMidY(containerBounds) - height / 2), width, height)
    }
    
    func calculateFinalFrame(containerBounds: CGRect) -> CGRect {
        let x = ceil((containerBounds.width - formSize.width) * 0.5)
        let y = ceil((containerBounds.height - formSize.height) * 0.5)
        return CGRectMake(x, y, formSize.width, formSize.height)
    }
    
    // MARK:- UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = fromViewController.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = toViewController.view
        
        let duration = self.transitionDuration(transitionContext)
        
        toView.autoresizingMask = UIViewAutoresizing.FlexibleHeight.union(.FlexibleWidth)
        
        if presenting {
            let dimView = UIView(frame: containerView.bounds)
            dimView.backgroundColor = UIColor(named: .Dim)
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: toViewController.transitioningDelegate!, action: #selector(FormSheetAnimator.didTapDimView(_:))))
            dimView.tag = dimViewTag
            containerView.addSubview(dimView)
            containerView.addSubview(toView)
            presentView(toView, presentingView: fromView, dimView: dimView, animationDuration: duration, containerView: containerView, completion: { _ in
                transitionContext.completeTransition(true)
            })
            
        } else {
            let dimView = containerView.viewWithTag(dimViewTag)!
            dimView.removeGestureRecognizer(dimView.gestureRecognizers![0])
            dismissView(fromView, presentingView: toView, dimView: dimView, animationDuration: duration, containerView: containerView, completion: { completed in
                dimView.removeFromSuperview()
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}