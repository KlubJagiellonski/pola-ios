import UIKit

protocol PaymentFailureViewDelegate: class {
    func paymentFailureViewDidTapLink(view: PaymentFailureView)
    func paymentFailureViewDidTapGoToMain(view: PaymentFailureView)
}

class PaymentFailureView: UIView {
    
    private let horizontalMargin: CGFloat = 18.0
    
    private let label = UILabel()
    private let imageView = UIImageView(image: UIImage(asset: .Kasa_fail))
    private let linkLabel = UILabel()
    private let button = UIButton()
    
    weak var delegate: PaymentFailureViewDelegate?
    
    init(orderNumber: Int) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        label.text = tr(.CheckoutPaymentResultFailureHeader)
        label.font = UIFont.latoHeavy(ofSize: 18.0)
        label.numberOfLines = 1
        label.textAlignment = .Center
        
        let linkString = tr(.CheckoutPaymentResultWebsiteLink)
        linkLabel.attributedText = tr(.CheckoutPaymentResultFailureDescription(String(orderNumber), linkString)).stringWithHighlightedSubsttring(linkString)
        linkLabel.font = UIFont.latoRegular(ofSize: 14.0)
        linkLabel.numberOfLines = 0
        linkLabel.lineBreakMode = .ByWordWrapping

        let tap = UITapGestureRecognizer(target: self, action: #selector(PaymentFailureView.didTapLinkLabel))
        linkLabel.addGestureRecognizer(tap)
        linkLabel.userInteractionEnabled = true
        
        button.setTitle(tr(.CheckoutPaymentResultGoToMain), forState: .Normal)
        button.addTarget(self, action: #selector(PaymentFailureView.didTapGoToMainButton), forControlEvents: .TouchUpInside)
        button.applyBlueStyle()

        addSubview(label)
        addSubview(imageView)
        addSubview(linkLabel)
        addSubview(button)
        
        configureCustomConstraints()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapLinkLabel() {
        delegate?.paymentFailureViewDidTapLink(self)
    }
    
    func didTapGoToMainButton() {
        delegate?.paymentFailureViewDidTapGoToMain(self)
    }
    
    func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(imageView.snp_top)
            make.leading.equalToSuperview().offset(horizontalMargin)
            make.trailing.equalToSuperview().offset(-horizontalMargin)
        }
        imageView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp_centerY)
        }
        linkLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView.snp_bottom)
            make.bottom.equalTo(button.snp_top)
            make.leading.equalToSuperview().offset(horizontalMargin)
            make.trailing.equalToSuperview().offset(-horizontalMargin)
        }
        button.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
}