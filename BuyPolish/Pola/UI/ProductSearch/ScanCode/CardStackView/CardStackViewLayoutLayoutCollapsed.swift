import UIKit

final class CardStackViewLayoutLayoutCollapsed: CardStackViewLayout {
    var stackView: CardStackView!
    var layoutContext: CardStackViewLayoutContext!
    private let offScreenCard: UIView?

    init(offScreenCard: UIView? = nil) {
        self.offScreenCard = offScreenCard
    }

    func willBecomeActive() {}
    func didBecomeInactive() {}
    func willBecomeInactive() {}
    func didBecomeActive() {}

    func layout(cards: [UIView]) {
        var cardFromBottom = 0
        cards.forEach { card in
            let y: CGFloat
            if card == offScreenCard {
                y = stackView.bounds.height
            } else {
                y = stackView.bounds.height - layoutContext.edgeInsets.bottom - layoutContext.lookAhead * CGFloat(cardFromBottom + 1)
            }
            card.frame = CGRect(
                x: layoutContext.edgeInsets.left,
                y: y,
                width: layoutContext.cardSize.width,
                height: layoutContext.cardSize.height
            )
            cardFromBottom += 1
        }
    }

    func didTap(cardView: UIView, recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else {
            return
        }

        let newLayout = CardStackViewLayoutLayoutExpanded(selectedCard: cardView)
        stackView.setCurrentLayout(newLayout, animated: true, completionBlock: nil)
    }

    func didPan(cardView: UIView, recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .began else {
            return
        }

        let newLayout = CardStackViewLayoutPick(selectedCard: cardView, panGestureRecognizer: recognizer)
        stackView.setCurrentLayout(newLayout, animated: false, completionBlock: nil)
    }
}
