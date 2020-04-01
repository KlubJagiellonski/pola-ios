import UIKit

final class CompanyContentView: UIView {

    let capitalTitleLabel = UILabel()
    let capitalProgressView = SecondaryProgressView()
    let notGlobalCheckRow = CheckRow()
    let registeredCheckRow = CheckRow()
    let rndCheckRow = CheckRow()
    let workersCheckRow = CheckRow()
    let friendButton = UIButton()
    let descriptionLabel = UILabel()
    private let padding = CGFloat(14)

    override init(frame: CGRect) {
        super.init(frame: frame)

        let localizable = R.string.localizable.self
        capitalTitleLabel.font = Theme.normalFont
        capitalTitleLabel.textColor = Theme.defaultTextColor
        capitalTitleLabel.text = localizable.percentOfPolishHolders()
        capitalTitleLabel.sizeToFit()
        addSubview(capitalTitleLabel)
        
        capitalProgressView.sizeToFit()
        addSubview(capitalProgressView)
        
        notGlobalCheckRow.text = localizable.notPartOfGlobalCompany()
        notGlobalCheckRow.sizeToFit()
        addSubview(notGlobalCheckRow)
        
        registeredCheckRow.text = localizable.isRegisteredInPoland()
        registeredCheckRow.sizeToFit()
        addSubview(registeredCheckRow)
        
        rndCheckRow.text = localizable.createdRichSalaryWorkPlaces()
        rndCheckRow.sizeToFit()
        addSubview(rndCheckRow)
        
        workersCheckRow.text = localizable.producingInPL()
        workersCheckRow.sizeToFit()
        addSubview(workersCheckRow)
        
        friendButton.setImage(R.image.heartFilled(), for: .normal)
        friendButton.tintColor = Theme.actionColor
        friendButton.setTitle(localizable.thisIsPolaSFriend(),
                              for: .normal)
        friendButton.setTitleColor(Theme.actionColor, for: .normal)
        friendButton.titleLabel?.font = Theme.normalFont
        let buttontitleHorizontalMargin = CGFloat(7)
        friendButton.titleEdgeInsets =
            UIEdgeInsets(top: 0, left: buttontitleHorizontalMargin, bottom: 0, right: 0)
        friendButton.contentHorizontalAlignment = .left
        friendButton.adjustsImageWhenHighlighted = false
        friendButton.isHidden = true
        addSubview(friendButton)
        
        descriptionLabel.font = Theme.normalFont
        descriptionLabel.textColor = Theme.defaultTextColor
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        var rect = capitalTitleLabel.frame
        rect.origin = .zero
        capitalTitleLabel.frame = rect
        var lastY = rect.maxY
        
        rect = capitalProgressView.frame
        rect.size.width = width
        rect.origin = CGPoint(x: 0, y: lastY + CGFloat(10))
        capitalProgressView.frame = rect
        lastY = rect.maxY
        
        lastY = layout(view: workersCheckRow, y: lastY)
        lastY = layout(view: rndCheckRow, y: lastY)
        lastY = layout(view: registeredCheckRow, y: lastY)
        lastY = layout(view: notGlobalCheckRow, y: lastY)

        if !friendButton.isHidden {
            lastY = layout(view: friendButton, y: lastY)
            friendButton.frame.size.width = width
        }
        
        if !(descriptionLabel.text?.isEmpty ?? false) {
            rect = descriptionLabel.frame
            rect.size.width = width
            rect.size.height = descriptionLabel.height(forWidth: width)
            rect.origin = CGPoint(x: 0, y: lastY + padding)
            descriptionLabel.frame = rect
            lastY = rect.maxY
        }

    }
    
    private func layout(view: UIView, y: CGFloat) -> CGFloat {
        view.frame = CGRect(
            origin: CGPoint(x: 0, y: y + padding),
            size: view.sizeThatFits(CGSize(width: frame.width, height: 0))
        )
        return view.frame.maxY
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = size.width
        var height = capitalProgressView.frame.height
        height += padding
        height += capitalProgressView.frame.height
        height += padding
        height += workersCheckRow.sizeThatFits(size).height
        height += padding
        height += rndCheckRow.sizeThatFits(size).height
        height += padding
        height += registeredCheckRow.sizeThatFits(size).height
        height += padding
        height += notGlobalCheckRow.sizeThatFits(size).height
        if !friendButton.isHidden {
            height += padding
            height += friendButton.sizeThatFits(size).height
        }
        if !(descriptionLabel.text?.isEmpty ?? false) {
            height += padding
            height += descriptionLabel.height(forWidth: width)
        }
        
        return CGSize(width: width, height: height)
    }

}
