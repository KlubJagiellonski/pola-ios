import Foundation
import UIKit

class PresenterView: UIView {
    private var hiddenContentView: UIView?
    private var contentView: UIView?
    private var modalView: UIView? {
        didSet {
            if let modal = modalView {
                addSubview(modal)
                modal.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            oldValue?.removeFromSuperview()
        }
    }
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
}