import UIKit

final class ScanResultView: UIView {
    
    let titleLabel = UILabel()
    let loadingProgressView = UIActivityIndicatorView(style: .gray)
    let mainProgressView = MainProggressView()
    var contentView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let contentView = contentView{
                scrollViewForContentView.addSubview(contentView)
            }
            setNeedsLayout()
        }
    }
    
    let teachButton = UIButton(type: .custom)
    let reportProblemButton = UIButton(type: .custom)
    let reportInfoLabel = UILabel()
    let separatorView = UIView()
    let heartImageView = UIImageView(image: R.image.heartFilled()!)
    let scrollViewForContentView = UIScrollView()
    
    var titleHeight = CGFloat(50)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.clearColor
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowRadius = 1
        layer.shadowOpacity =  0.2
        
        accessibilityViewIsModal = true
        
        loadingProgressView.sizeToFit()
        addSubview(loadingProgressView)
        
        titleLabel.font = Theme.titleFont
        titleLabel.textColor = Theme.defaultTextColor
        titleLabel.accessibilityTraits = .header
        titleLabel.accessibilityHint = R.string.localizable.accessibilityCardHint()
        addSubview(titleLabel)
        
        heartImageView.tintColor = Theme.actionColor
        heartImageView.isHidden = true
        addSubview(heartImageView)
        
        mainProgressView.sizeToFit()
        addSubview(mainProgressView)
        
        teachButton.titleLabel?.font = Theme.buttonFont
        teachButton.layer.borderColor = Theme.actionColor.cgColor
        teachButton.layer.borderWidth = 1
        teachButton.setTitleColor(Theme.actionColor, for: .normal)
        teachButton.setTitleColor(Theme.clearColor, for: .highlighted)
        teachButton.setBackgroundImage(UIImage.image(color: UIColor.clear), for: .normal)
        teachButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .highlighted)
        teachButton.sizeToFit()
        addSubview(teachButton)
        
        reportProblemButton.titleLabel?.font = Theme.buttonFont
        reportProblemButton.sizeToFit()
        addSubview(reportProblemButton)
        
        reportInfoLabel.numberOfLines = 3
        reportInfoLabel.font = Theme.normalFont
        reportInfoLabel.textColor = Theme.defaultTextColor
        reportInfoLabel.sizeToFit()
        addSubview(reportInfoLabel)
        
        scrollViewForContentView.showsVerticalScrollIndicator = true
        addSubview(scrollViewForContentView)
        
        separatorView.backgroundColor = Theme.lightBackgroundColor
        addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentProgreassInHeaderHeight = CGFloat(6)
        let buttonHeight = CGFloat(30)
        let horizontalPadding = CGFloat(10)
        let verticalPadding = CGFloat(14)

        let verticalTitleSpace = titleHeight - contentProgreassInHeaderHeight
        let widthWithPadding = bounds.width - (2 * horizontalPadding)
        
        titleLabel.sizeToFit()
        var rect = titleLabel.frame
        rect.origin.x = horizontalPadding
        rect.origin.y = (verticalTitleSpace / 2) - (rect.height / 2)
        rect.size.width = widthWithPadding
        titleLabel.frame = rect
        
        if !heartImageView.isHidden {
            heartImageView.sizeToFit()
            rect.size.width -= heartImageView.frame.width + verticalPadding
            titleLabel.frame = rect
            
            rect.origin.y -= (heartImageView.frame.height - titleLabel.frame.height) / 2
            rect.origin.x = titleLabel.frame.maxX + verticalPadding
            rect.size = heartImageView.frame.size
            heartImageView.frame = rect
        }
        
        rect = loadingProgressView.frame
        rect.origin.x = bounds.width - verticalPadding - loadingProgressView.bounds.width
        rect.origin.y = (verticalTitleSpace / 2) - (rect.height / 2)
        loadingProgressView.frame = rect
        
        rect = mainProgressView.frame
        rect.size.width = bounds.width
        rect.origin = CGPoint(x: 0, y: verticalTitleSpace)
        mainProgressView.frame = rect
        
        rect = reportProblemButton.frame
        rect.size = CGSize(width: widthWithPadding, height: buttonHeight)
        rect.origin.x = horizontalPadding
        rect.origin.y = bounds.height - verticalPadding - rect.height
        reportProblemButton.frame = rect
        
        rect = reportInfoLabel.frame
        rect.size.width = widthWithPadding
        rect.size.height = reportInfoLabel.height(forWidth: widthWithPadding)
        rect.origin.x = horizontalPadding
        rect.origin.y = reportProblemButton.frame.minY - verticalPadding - rect.height
        reportInfoLabel.frame = rect
        
        if !teachButton.isHidden {
            rect = teachButton.frame
            rect.size = CGSize(width: widthWithPadding, height: buttonHeight)
            rect.origin.x = horizontalPadding
            rect.origin.y = reportInfoLabel.frame.minY - verticalPadding - rect.height
            teachButton.frame = rect
        }
        
        rect = separatorView.frame
        rect.size.width = bounds.width
        rect.size.height = 1
        rect.origin.x = 0
        let viewUnderSeparator = teachButton.isHidden ? reportInfoLabel : teachButton
        rect.origin.y = viewUnderSeparator.frame.minY - 15 - rect.height
        separatorView.frame = rect
        
        rect = scrollViewForContentView.frame
        rect.size.width = bounds.width
        rect.size.height = separatorView.frame.minY - mainProgressView.frame.maxY
        rect.origin.x = 0
        rect.origin.y = mainProgressView.frame.maxY
        scrollViewForContentView.frame = rect
        
        if let contentView = contentView {
            rect = contentView.frame
            rect.origin.x = horizontalPadding
            rect.origin.y = verticalPadding
            rect.size = contentView.sizeThatFits(CGSize(width: widthWithPadding, height: 0))
            contentView.frame = rect
            scrollViewForContentView.contentSize = CGSize(width: bounds.width, height: rect.maxY + verticalPadding)
        } else {
            scrollViewForContentView.contentSize = .zero
        }
        
    }
    
}
