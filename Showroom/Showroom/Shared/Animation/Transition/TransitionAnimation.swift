import Foundation
import UIKit

typealias ContainerView = UIView
typealias PresentedView = UIView
typealias PresentationView = UIView

protocol TransitionAnimation {
    func show(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?)
    func hide(containerView: ContainerView, presentedView: PresentedView, presentationView: PresentationView?, completion: ((Bool) -> ())?)
}
