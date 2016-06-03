import Foundation
import UIKit

class PresenterView: UIView {
    var contentView: UIView? {
        didSet {
            if let content = contentView {
                addSubview(content)
                configureCustomConstraints()
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    var modalView: UIView? {
        didSet {
            if let modal = modalView {
                addSubview(modal)
                configureCustomConstraints()
            }
            oldValue?.removeFromSuperview()
        }
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