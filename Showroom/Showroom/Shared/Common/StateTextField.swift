import Foundation
import UIKit

enum StateTextFieldState {
    case Default
    case Correct
    case Invalid
    
    var image: UIImage? {
        switch self {
        case .Default:
            return nil
        case .Correct:
            return UIImage(asset: .Ic_tick)
        case .Invalid:
            return UIImage(asset: .Ic_cross_red)
        }
    }
}

class StateTextField: UITextField {
    private let stateImageView = UIImageView()
    private let imageSize = CGSizeMake(15, 15)
    private let rightMargin: CGFloat = 11
    private let leftMargin: CGFloat = 4
    
    var imageState: StateTextFieldState = .Default {
        didSet {
            stateImageView.image = imageState.image
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        stateImageView.contentMode = .Center
        addSubview(stateImageView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return calculateRect(super.textRectForBounds(bounds))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return calculateRect(super.editingRectForBounds(bounds))
    }
    
    private func configureCustomConstraints() {
        stateImageView.snp_makeConstraints { make in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
            make.trailing.equalToSuperview().inset(rightMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func calculateRect(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.minX + leftMargin, bounds.minY, bounds.width - imageSize.width - rightMargin, bounds.height)
    }
}
