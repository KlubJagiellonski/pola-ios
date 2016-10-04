import Foundation
import UIKit

final class PromoSummaryLinksView: UIView {
    weak var promoSummaryView: PromoSummaryView?
    
    private let linkButtons: [UIButton]
    private let links: [PromoSlideshowLink]
    
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
        
        let horizontalMargin = Dimensions.defaultMargin
        let linkWidth = bounds.width - 2 * horizontalMargin
        let linkHeight: CGFloat = linkButtons.first?.bounds.height ?? 0
        let space = (bounds.height - CGFloat(linkButtons.count) * linkHeight) / CGFloat(linkButtons.count + 1)
        var y = space
        for linkButton in linkButtons {
            linkButton.frame = CGRect(x: horizontalMargin, y: y, width: linkWidth, height: linkHeight)
            y += linkHeight + space
        }
    }
    
    @objc private func didTapLinkButton(button: UIButton) {
        guard let index = linkButtons.indexOf(button) else {
            logError("Cannot find index for button \(button), linkButtons \(linkButtons)")
            return
        }
        promoSummaryView?.didTap(link: links[index])
    }

}