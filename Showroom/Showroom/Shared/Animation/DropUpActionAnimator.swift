import UIKit

class DropUpActionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    let height: CGFloat
    
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
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropUpAnimatedTransitioning(height: height, presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropUpAnimatedTransitioning(height: height, presenting: false)
    }
}


class DropUpAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let height: CGFloat
    
    init(height: CGFloat, presenting: Bool) {
        self.height = height
        self.presenting = presenting
        super.init()
    }
    
    func presentView(presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((completed: Bool) -> Void)?) {
        presentedView.frame = CGRect(x: 0, y: presentingView.bounds.maxY, width: presentingView.bounds.width, height: height)
        presentedView.frame.origin = CGPoint(x: CGFloat(0), y: presentingView.bounds.maxY)
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            presentedView.frame.origin.y -= self.height
            // dimm presenting view
            }, completion: { finished in
                completion?(completed: finished)
        })
    }
    
    func dismissView(presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((completed: Bool) -> Void)?) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            presentedView.frame.origin.y += presentedView.frame.height
            // un-dimm presenting view
            }, completion: { finished in
                completion?(completed: finished)
        })
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
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
            containerView?.addSubview(toView)
            presentView(toView, presentingView: fromView, animationDuration: duration, completion: { _ in
                transitionContext.completeTransition(true)
            })
            
        } else {
            dismissView(fromView, presentingView: toView, animationDuration: duration, completion: { completed in
                if completed { fromView.removeFromSuperview() }
                transitionContext.completeTransition(true)
            })
        }
    }
}