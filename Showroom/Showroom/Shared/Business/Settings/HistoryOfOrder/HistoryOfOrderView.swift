import UIKit

protocol HistoryOfOrderViewDelegate: class {
    func historyOfOrderViewdidTapGoToWebsite(view: HistoryOfOrderView)
}

class HistoryOfOrderView: UIView {
    private let labelToNotebookOffset: CGFloat
    private let labelHorizontalInset: CGFloat = 32.0
    
    private let contentView = UIView()
    private let notebookImageView = UIImageView(image: UIImage(asset: .History))
    private let label = UILabel()
    
    weak var delegate: HistoryOfOrderViewDelegate?
    
    private var attributedInfoString: NSAttributedString {
        let linkString = tr(.SettingsHistoryGoToWebsite)
        let attributedString = tr(.SettingsHistoryToCheckHistory("\n" + linkString)).stringWithHighlightedSubsttring(linkString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.0
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    init() {
        switch UIDevice.currentDevice().screenType {
        case .iPhone4, .iPhone5:
            labelToNotebookOffset = 50.0
        case .iPhone6, .iPhone6Plus:
            labelToNotebookOffset = 70.0
        default:
            labelToNotebookOffset = 70.0
        }
                
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        label.attributedText = attributedInfoString
        label.font = UIFont(fontType: .Normal)
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HistoryOfOrderView.didTapGoToWebsite))
        label.addGestureRecognizer(tap)
        
        contentView.addSubview(notebookImageView)
        contentView.addSubview(label)
        
        addSubview(contentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapGoToWebsite(sender: UITapGestureRecognizer) {
        delegate?.historyOfOrderViewdidTapGoToWebsite(self)
    }
    
    func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        notebookImageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        label.snp_makeConstraints { make in
            make.top.equalTo(notebookImageView.snp_bottom).offset(labelToNotebookOffset)
            make.leading.equalToSuperview().offset(labelHorizontalInset)
            make.trailing.equalToSuperview().offset(-labelHorizontalInset)
            make.bottom.equalToSuperview()
        }
    }
}