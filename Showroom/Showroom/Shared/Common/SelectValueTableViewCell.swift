import UIKit
import SnapKit

enum SelectAccessoryType {
    case None, Checkmark, GoTo, Loading
}

class SelectValueTableViewCell: UITableViewCell {
    private let colorIconView = ColorIconView()
    private let titleLabel = UILabel()
    private let separatorView = UIView()
    
    private var titleLabelFont: UIFont {
        return UIFont(fontType: .Normal)
    }
    private var imageEnabled: Bool {
        return false
    }
    private var leftOffsetConstraint: Constraint!
    var selectAccessoryType: SelectAccessoryType = .None {
        didSet {
            switch selectAccessoryType {
            case .None:
                accessoryView = nil
            case .Checkmark:
                accessoryView = UIImageView(image: UIImage(asset: .Ic_tick))
            case .GoTo:
                accessoryView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
            case .Loading:
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                indicator.startAnimating()
                accessoryView = indicator
            }
        }
    }
    var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    var titleFont: UIFont {
        set { titleLabel.font = newValue }
        get { return titleLabel.font }
    }
    var leftOffset: CGFloat = Dimensions.defaultMargin {
        didSet {
            guard leftOffset != oldValue else { return }
            leftOffsetConstraint.updateOffset(leftOffset)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = titleLabelFont
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        if imageEnabled { contentView.addSubview(colorIconView) }
        contentView.addSubview(titleLabel)
        addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorRepresentation(colorRepresentation: ColorRepresentation) {
        colorIconView.setColorRepresentation(colorRepresentation)
    }
    
    func setColorAvailability(available: Bool) {
        if available {
            colorIconView.alpha = 1
            titleLabel.textColor = UIColor(named: .Black)
        } else {
            colorIconView.alpha = 0.2
            titleLabel.textColor = UIColor(named: .DarkGray)
        }
    }
        
    private func configureCustomConstraints() {
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        if imageEnabled {
            let colorIconSide: CGFloat = 25
            colorIconView.snp_makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(colorIconSide)
                leftOffsetConstraint = make.leading.equalToSuperview().offset(leftOffset).constraint
                make.width.equalTo(colorIconSide)
            }
            titleLabel.snp_makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalTo(colorIconView.snp_trailing).offset(Dimensions.defaultMargin)
                make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            }
        } else {
            titleLabel.snp_makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                leftOffsetConstraint = make.leading.equalToSuperview().inset(leftOffset).constraint
                make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            }
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
}

final class ImageSelectValueTableViewCell: SelectValueTableViewCell {
    private override var imageEnabled: Bool {
        return true
    }
}

final class BoldSelectValueTableViewCell: SelectValueTableViewCell {
    private override var titleLabelFont: UIFont {
        return UIFont(fontType: .Bold)
    }
}

class SmallSelectValueTableViewCell: SelectValueTableViewCell {
    private override var titleLabelFont: UIFont {
        return UIFont(fontType: .ProductActionOption)
    }
}

final class ImageSmallSelectValuTableViewCell: SmallSelectValueTableViewCell {
    private override var imageEnabled: Bool {
        return true
    }
}