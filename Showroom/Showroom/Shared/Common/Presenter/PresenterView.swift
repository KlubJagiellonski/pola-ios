import Foundation
import UIKit

typealias ContainerView = UIView
typealias ContentView = UIView
typealias ModalView = UIView

class PresenterView: UIView {
    var contentView: UIView? {
        didSet {
            if let content = contentView {
                insertSubview(content, atIndex: 0)
                configureCustomConstraints()
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    private var modalView: UIView? {
        didSet {
            if let modal = modalView {
                addSubview(modal)
                configureCustomConstraints()
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    func showModal(view: ModalView, customAnimation: ((ContainerView, ContentView?, ModalView, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        guard self.modalView == nil else { fatalError("Cannot show modal view when there is existing one") }
        
        self.modalView = view
        
        if let customAnimation = customAnimation {
            customAnimation(self, contentView, view, completion)
            return
        }
        
        addSubview(view)
        configureCustomConstraints()
        completion?(true)
    }
    
    func hideModal(customAnimation: ((ContainerView, ContentView?, ModalView, ((Bool) -> ())?) -> ())?, completion: ((Bool) -> ())?) {
        guard let modalView = modalView else { fatalError("Cannot hide modal view when there is no existing one") }
        
        let innerCompletion: (Bool) -> () = { [weak self] success in
            completion?(success)
            self?.modalView = nil
        }
        
        if let customAnimation = customAnimation {
            customAnimation(self, contentView, modalView, innerCompletion)
            return
        }
        
        modalView.removeFromSuperview()
        innerCompletion(true)
    }
    
    func configureCustomConstraints() {
        guard let content = contentView else { return }
        
        content.snp_remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        guard let modal = modalView else { return }
        modal.snp_remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}