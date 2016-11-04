import Foundation
import UIKit
import SnapKit

protocol ModalPanDismissDelegate: class {
    func modalPanDidMove(withTranslation translation: CGPoint, velocity: CGPoint, state: UIGestureRecognizerState)
}

protocol ModalPanDismissable: class {
    weak var modalPanDismissDelegate: ModalPanDismissDelegate? { get set }
}

protocol PresenterViewDelegate: class {
    func presenterWantsToHideModalView(view: PresenterView)
    func presenterWillBeginHideModalPanning(view: PresenterView)
    func presenterDidEndHideModalPanning(view: PresenterView)
}

final class PresenterView: UIView, ModalPanDismissDelegate {
    private var hiddenContentView: UIView?
    private var contentView: UIView?
    private var modalView: UIView? {
        didSet {
            if let modal = modalView {
                addSubview(modal)
                if let panDismissable = modal as? ModalPanDismissable {
                    panDismissable.modalPanDismissDelegate = self
                }
                modal.snp_makeConstraints { make in
                    self.modalViewTopConstraint = make.top.equalToSuperview().constraint
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalToSuperview()
                }
            }
            oldValue?.removeFromSuperview()
        }
    }
    private var modalDimView: UIView? {
        didSet {
            if let dimView = modalDimView, let modalView = modalView {
                insertSubview(dimView, belowSubview: modalView)
                dimView.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            oldValue?.removeFromSuperview()
        }
    }
    private var modalViewTopConstraint: Constraint?
    var contentHidden: Bool {
        set {
            guard let contentView = contentView else { return }
            if newValue {
                contentView.removeFromSuperview()
            } else if contentView.superview == nil {
                insertSubview(contentView, atIndex: 0)
                contentView.snp_remakeConstraints() { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        get { return contentView?.superview == nil }
    }
    weak var delegate: PresenterViewDelegate?
    
    func showContent(view: PresentedView, customAnimation: ((ContainerView, PresentedView, PresentationView?, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        insertSubview(view, atIndex: 0)
        view.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.userInteractionEnabled = false
        let innerCompletion: (Bool) -> () = { [weak self] success in
            self?.userInteractionEnabled = true
            self?.contentView?.removeFromSuperview()
            self?.contentView = view
            completion?(success)
        }
        
        if let customAnimation = customAnimation {
            customAnimation(self, view, contentView, innerCompletion)
        } else {
            innerCompletion(true)
        }
    }
    
    func showModal(view: PresentedView, customAnimation: ((ContainerView, PresentedView, PresentationView?, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        guard self.modalView == nil else { fatalError("Cannot show modal view when there is existing one") }
        
        self.modalView = view
        
        self.userInteractionEnabled = false
        let innerCompletion = { [weak self] (success: Bool) in
            self?.userInteractionEnabled = true
            completion?(success)
        }
        
        if let customAnimation = customAnimation {
            customAnimation(self, view, nil, innerCompletion)
        } else {
            innerCompletion(true)
        }
    }
    
    func hideModal(customAnimation: ((ContainerView, PresentedView, PresentationView?, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        guard let modalView = modalView else { fatalError("Cannot hide modal view when there is no existing one") }
        
        self.userInteractionEnabled = false
        let innerCompletion: (Bool) -> () = { [weak self] success in
            self?.userInteractionEnabled = true
            completion?(success)
            self?.modalView = nil
        }
        
        if let customAnimation = customAnimation {
            customAnimation(self, modalView, nil, innerCompletion)
        } else {
            innerCompletion(true)
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, withEvent: event) else { return nil }
        if let modalView = modalView where !view.isDescendantOfView(modalView) {
            return modalView //if modalView exist it should always receive touch
        }
        return view
    }
    
    // MARK:- ModalPanDismissDelegate
    
    // It is needed to know when user stopped panning for a while. In that case, when he end panning it won't close
    private var lastPanChange: CFAbsoluteTime = 0
    
    func modalPanDidMove(withTranslation translation: CGPoint, velocity: CGPoint, state: UIGestureRecognizerState) {
        switch state {
        case .Began:
            lastPanChange = CFAbsoluteTimeGetCurrent()
            self.delegate?.presenterWillBeginHideModalPanning(self)
            
            let dimView = UIView()
            dimView.backgroundColor = UIColor(named: .Dim)
            dimView.alpha = 1.0
            self.modalDimView = dimView
        case .Changed:
            lastPanChange = CFAbsoluteTimeGetCurrent()
            let offsetY = max(translation.y, 0)
            modalViewTopConstraint?.updateOffset(offsetY)
            self.modalDimView?.alpha = 1 - (offsetY / bounds.height)
        case .Ended:
            let timeElapseFromLastChange = CFAbsoluteTimeGetCurrent() - lastPanChange
            let shouldHideModal = velocity.y > 25 && timeElapseFromLastChange < 0.2
            
            self.layoutIfNeeded()
            self.modalViewTopConstraint?.updateOffset(shouldHideModal ? bounds.height : 0)
            UIView.animateWithDuration(0.3, animations: { [unowned self] in
                self.modalDimView?.alpha = shouldHideModal ? 0 : 1
                self.layoutIfNeeded()
            }) { _ in
                if !shouldHideModal {
                    self.delegate?.presenterDidEndHideModalPanning(self)
                }
                self.modalDimView = nil
            }
            if shouldHideModal {
                self.delegate?.presenterWantsToHideModalView(self)
            }
        case .Cancelled:
            self.modalDimView = nil
        default: break
        }
    }
}
