import UIKit

protocol DropUpActionDelegate: class {
    func dropUpActionDidTapDimView(animator: DropUpActionAnimator)
}

class DropUpActionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    let height: CGFloat
    
    weak var delegate: DropUpActionDelegate?
    
    init(height: CGFloat) {
        self.height = height
        super.init()
    }
    
    func presentViewController(presentedVC: UIViewController, presentingVC: UIViewController) {
        presentedVC.modalPresentationStyle = .Custom
        presentedVC.modalTransitionStyle = .CoverVertical
        presentedVC.transitioningDelegate = self
        
        presentingVC.presentViewController(presentedVC, animated: true, completion: nil)
    }
    
    func dismissViewController(presentingViewController presentingViewController: UIViewController) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapDimView(sender: UITapGestureRecognizer) {
        delegate?.dropUpActionDidTapDimView(self)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropUpAnimatedTransitioning(height: height, presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropUpAnimatedTransitioning(height: height, presenting: false)
    }
}


class DropUpAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
    let dimViewAlpha: CGFloat = 0.2
    let dimViewColor = UIColor(named: .Black)
    private let dimViewTag = "DIM_VIEW_TAG".hash
    let transitionDuration = 0.3
    
    let presenting: Bool
    let height: CGFloat
    
    init(height: CGFloat, presenting: Bool) {
        self.height = height
        self.presenting = presenting
        super.init()
    }
    
    func presentView(presentedView: UIView, presentingView: UIView, dimView: UIView, animationDuration: Double, completion: ((completed: Bool) -> Void)?) {
        presentedView.frame = CGRect(x: 0, y: presentingView.bounds.maxY, width: presentingView.bounds.width, height: height)
        presentedView.frame.origin = CGPoint(x: CGFloat(0), y: presentingView.bounds.maxY)
        dimView.alpha = 0
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            presentedView.frame.origin.y -= self.height
            dimView.alpha = self.dimViewAlpha
            }, completion: { finished in
                completion?(completed: finished)
        })
    }
    
    func dismissView(presentedView: UIView, presentingView: UIView, dimView: UIView, animationDuration: Double, completion: ((completed: Bool) -> Void)?) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            presentedView.frame.origin.y += presentedView.frame.height
            dimView.alpha = 0
            }, completion: { finished in
                completion?(completed: finished)
        })
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = fromViewController.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = toViewController.view
        
        let duration = self.transitionDuration(transitionContext)
        
        toView.autoresizingMask = UIViewAutoresizing.FlexibleHeight.union(.FlexibleWidth)
        
        if presenting {
            let dimView = UIView(frame: containerView!.bounds)
            dimView.backgroundColor = dimViewColor
            let animator = toViewController.transitioningDelegate!
            let tapGesture = UITapGestureRecognizer(target: animator, action: #selector(DropUpActionAnimator.didTapDimView(_:)))
            dimView.addGestureRecognizer(tapGesture)
            dimView.tag = dimViewTag
            containerView?.addSubview(dimView)
            containerView?.addSubview(toView)
            presentView(toView, presentingView: fromView, dimView: dimView, animationDuration: duration, completion: { _ in
                transitionContext.completeTransition(true)
            })
            
        } else {
            let dimView = (containerView?.viewWithTag(dimViewTag))!            
            dismissView(fromView, presentingView: toView, dimView: dimView, animationDuration: duration, completion: { completed in
                dimView.removeFromSuperview()
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}