import UIKit

protocol CheckoutSummaryPaymentOptionCellDelegate: class {
    func optionCellDidChangeToSelectedState(cell: CheckoutSummaryPaymentOptionCell)
}

class CheckoutSummaryPaymentOptionCell: UITableViewCell {
    private let radio = RadioButton()
    weak var delegate: CheckoutSummaryPaymentOptionCellDelegate?
    var title: String? {
        get { return radio.title }
        set { radio.title = newValue }
    }
    var optionSelected: Bool {
        get { return radio.selected }
        set { radio.selected = newValue }
    }
    static var height: CGFloat {
        return Dimensions.defaultCellHeight
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        configureViews()
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        radio.addTarget(self, action: #selector(CheckoutSummaryPaymentOptionCell.didChangeValue), forControlEvents: .ValueChanged)
        
        contentView.addSubview(radio)
    }
    
    private func configureCustomConstraints() {
        radio.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.top.equalToSuperview()
        }
    }
    
    @objc private func didChangeValue() {
        optionSelected = true
        delegate?.optionCellDidChangeToSelectedState(self)
    }
}

final class CheckoutSummaryPayuOptionCell: CheckoutSummaryPaymentOptionCell {
    static let payUButtonHeight: CGFloat = 50
    
    private let payuContainerView = PayUContainerView()
    var payUButton: UIView? {
        set { payuContainerView.payUButton = newValue }
        get { return payuContainerView.payUButton }
    }
    override var optionSelected: Bool {
        didSet {
            payuContainerView.enabled = optionSelected
        }
    }
    static var payUOptionCellHeight: CGFloat {
        return CheckoutSummaryPaymentOptionCell.height + CheckoutSummaryPayuOptionCell.payUButtonHeight + 12
    }
    
    private override func configureViews() {
        super.configureViews()
        
        contentView.addSubview(payuContainerView)
    }
    
    private override func configureCustomConstraints() {
        radio.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(-Dimensions.defaultMargin)
        }
        
        payuContainerView.snp_makeConstraints { make in
            make.top.equalTo(radio.snp_bottom)
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
    }
}

private class PayUContainerView: UIControl {
    var payUButton: UIView? {
        didSet {
            updateButtonState()
            if let button = payUButton {
                addSubview(button)
                button.snp_makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            oldValue?.removeFromSuperview()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        layer.borderColor = UIColor(hex: "E4E5E3")?.CGColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 50)
    }
    
    override var enabled: Bool {
        didSet { updateButtonState() }
    }
    
    private func updateButtonState() {
        payUButton?.alpha = enabled ? 1.0 : 0.3
        payUButton?.userInteractionEnabled = enabled
    }
}
