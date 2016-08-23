import UIKit

protocol ToastViewDelegate {
    func toastViewDidTapView(view: ToastView)
}

final class ToastWindow: UIWindow {
    private let toastMargin: CGFloat = 5
    private let animationDuration = 0.4
    
    private(set) var currentToastView: ToastView?
    private(set) var animationInProgress = false
    
    func showMessages(messages: [String], completion: (() -> ())? = nil) {
        guard currentToastView == nil else { fatalError("Cannot show message when there are existing ones") }
        
        currentToastView = ToastView(messages: messages)
        currentToastView?.alpha = 0
        addSubview(currentToastView!)
        currentToastView?.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(toastMargin)
            make.trailing.equalToSuperview().inset(toastMargin)
        }
        
        animationInProgress = true
        
        UIView.animateWithDuration(animationDuration, animations: { [unowned self] in
            self.currentToastView?.alpha = 1
        }) { [weak self] success in
            self?.animationInProgress = false
            completion?()
        }
    }
    
    func hideMessages(completion: (() -> ())? = nil) {
        guard let toastView = currentToastView else {
            completion?()
            return
        }
        
        animationInProgress = true
        
        toastView.alpha = 1
        UIView.animateWithDuration(animationDuration, animations: {
            toastView.alpha = 0
        }) { [weak self] success in
            toastView.removeFromSuperview()
            self?.currentToastView = nil
            self?.animationInProgress = false
            completion?()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let toastView = currentToastView {
            frame = CGRectMake(0, 0, self.bounds.width, toastView.bounds.height + 20)
        }
    }
}

final class ToastView: UIView {
    private let maxItems = 3
    
    private let closeImageView = UIImageView(image: UIImage(asset: .Ic_close_toast))
    private let itemsStackView = UIStackView()
    
    init(messages: [String]) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: .Black).CGColor
        layer.shadowRadius = 2
        layer.shadowColor = UIColor(named: .Black).CGColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSizeZero
        
        itemsStackView.axis = .Vertical
        itemsStackView.distribution = .EqualSpacing
        
        for (index, message) in messages.enumerate() {
            let rowView = ToastRowView(frame: frame, text: message)
            rowView.topSeparator.hidden = index == 0
            itemsStackView.addArrangedSubview(rowView)
        }
        
        addSubview(itemsStackView)
        addSubview(closeImageView)
       
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        itemsStackView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let closeImageMargin: CGFloat = 8
        
        closeImageView.snp_makeConstraints { make in
            make.top.equalTo(closeImageMargin)
            make.leading.equalTo(closeImageMargin)
        }
    }
}

final class ToastRowView: UIView {
    private let defaultMargin: CGFloat = 12
    private let leftMargin: CGFloat = 52
    private let separatorHeight: CGFloat = 2
    
    private let textLabel = UILabel()
    private let topSeparator = UIView()
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        
        topSeparator.backgroundColor = UIColor(named: .Black)
        
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.font = UIFont(fontType: .Normal)
        
        addSubview(textLabel)
        addSubview(topSeparator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        textLabel.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(defaultMargin, leftMargin, defaultMargin, defaultMargin))
        }
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(separatorHeight)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let textWidth = bounds.width - defaultMargin - leftMargin
        let textHeight = textLabel.text?.heightWithConstrainedWidth(textWidth, font: textLabel.font) ?? 0
        return CGSizeMake(UIViewNoIntrinsicMetric, textHeight)
    }
}
