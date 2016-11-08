import Foundation
import UIKit

final class PromoSummaryLinksView: UIView {
    weak var promoSummaryView: PromoSummaryView?
    
    private let links: [PromoSlideshowLink]
    
    private let repeatButton = UIButton()
    private let separatorView = UIView()
    private let linkButtons: [UIButton]
    
    init(links: [PromoSlideshowLink]) {
        self.links = links
        self.linkButtons = links.flatMap { link in
            let button = UIButton()
            button.applyPlainBoldStyle()
            button.titleLabel!.font = UIFont(fontType: .Button)
            button.setTitle(link.text, forState: .Normal)
            button.sizeToFit()
            return button
        }
        
        super.init(frame: CGRectZero)
        
        repeatButton.addTarget(self, action: #selector(PromoSummaryLinksView.didTapRepeatButton), forControlEvents: .TouchUpInside)
        repeatButton.setImage(UIImage(asset: .Repeat), forState: .Normal)
        repeatButton.setTitle(tr(.PromoVideoSummaryRepeat), forState: .Normal)
        repeatButton.applyBlackPlainBoldStyle()
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        addSubview(repeatButton)
        addSubview(separatorView)
        
        linkButtons.forEach {
            $0.addTarget(self, action: #selector(PromoSummaryLinksView.didTapLinkButton), forControlEvents: .TouchUpInside)
            addSubview($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let repeatButtonHeight: CGFloat = UIDevice.currentDevice().screenType == .iPhone4 ? 40 : 46
        
        repeatButton.frame = CGRect(x: 0, y: 0, width: bounds.width, height: repeatButtonHeight)
        
        let horizontalMargin = Dimensions.defaultMargin
        let widthWithoutMargins = bounds.width - 2 * horizontalMargin
        let separatorHeight: CGFloat = Dimensions.boldSeparatorThickness

        separatorView.frame = CGRect(x: horizontalMargin, y: CGRectGetMaxY(repeatButton.frame), width: widthWithoutMargins, height: separatorHeight)
        
        let linkHeight: CGFloat = linkButtons.first?.bounds.height ?? 0
        let space = (bounds.height - CGRectGetMaxY(separatorView.frame) - CGFloat(linkButtons.count) * linkHeight) / CGFloat(linkButtons.count + 1)
        
        var y = CGRectGetMaxY(separatorView.frame) + space
        for linkButton in linkButtons {
            linkButton.frame = CGRect(x: horizontalMargin, y: y, width: widthWithoutMargins, height: linkHeight)
            y += linkHeight + space
        }
    }
    
    @objc private func didTapRepeatButton() {
        promoSummaryView?.didTapRepeatButton()
    }
    
    @objc private func didTapLinkButton(button: UIButton) {
        guard let index = linkButtons.indexOf(button) else {
            logError("Cannot find index for button \(button), linkButtons \(linkButtons)")
            return
        }
        promoSummaryView?.didTap(link: links[index])
    }
}
