import Foundation
import UIKit

typealias ContainerView = UIView
typealias PresentedView = UIView
typealias PresentationView = UIView

protocol TransitionAnimation: class {
    
    var additionalAnimationBlock: (Void -> Void)? { get set }
    
    func show(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?)
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?)
}
