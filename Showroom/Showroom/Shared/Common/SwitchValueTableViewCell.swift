import Foundation
import UIKit

protocol SwitchValueTableViewCellDelegate: class {
    func switchValue(cell: SwitchValueTableViewCell, didChangeValue value: Bool)
}

final class SwitchValueTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueSwitch = UISwitch()
    weak var delegate: SwitchValueTableViewCellDelegate?
    
    var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    
    var value: Bool {
        set { valueSwitch.on = newValue }
        get { return valueSwitch.on }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.textColor = UIColor(named: .Black)
        
        valueSwitch.onTintColor = UIColor(named: .Blue)
        valueSwitch.addTarget(self, action: #selector(SwitchValueTableViewCell.didChangeValue), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueSwitch)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeValue() {
        delegate?.switchValue(self, didChangeValue: value)
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        valueSwitch.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}
