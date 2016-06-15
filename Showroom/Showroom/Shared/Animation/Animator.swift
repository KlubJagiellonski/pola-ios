import Foundation
import UIKit

protocol Animator {
    func presentViewController(presentedViewController: UIViewController, presentingViewController: UIViewController)
    
    func dismissViewController(presentingViewController presentingViewController: UIViewController)
}

protocol DimAnimatorDelegate: class {
    func animatorDidTapOnDimView(animator: Animator)
}
