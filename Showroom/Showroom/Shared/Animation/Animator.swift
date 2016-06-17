import Foundation
import UIKit

protocol Animator {
    func presentViewController(presentedViewController: UIViewController, presentingViewController: UIViewController, completion: (() -> Void)?)
    
    func dismissViewController(presentingViewController presentingViewController: UIViewController, completion: (() -> Void)?)
}

protocol DimAnimatorDelegate: class {
    func animatorDidTapOnDimView(animator: Animator)
}
