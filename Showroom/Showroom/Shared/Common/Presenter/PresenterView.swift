import Foundation
import UIKit

class PresenterView: UIView {
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
    
    func showContent(view: PresentedView, customAnimation: ((ContainerView, PresentedView, PresentationView?, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        insertSubview(view, atIndex: 0)
        view.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let innerCompletion: (Bool) -> () = { [weak self] success in
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
        
        if let customAnimation = customAnimation {
            customAnimation(self, view, nil, completion)
        } else {
            completion?(true)
        }
    }
    
    func hideModal(customAnimation: ((ContainerView, PresentedView, PresentationView?, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        guard let modalView = modalView else { fatalError("Cannot hide modal view when there is no existing one") }
        
        let innerCompletion: (Bool) -> () = { [weak self] success in
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