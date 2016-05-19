import Foundation
import UIKit

class RootView : UIView {
    var contentView: UIView? {
        didSet {
            if let content = contentView {
                addSubview(content)
                configureCustomConstraints()
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    func configureCustomConstraints() {
        guard let content = contentView else { return }
        
        let superview = self
        content.snp_makeConstraints { make in
            make.edges.equalTo(superview)
        }
    }
}
