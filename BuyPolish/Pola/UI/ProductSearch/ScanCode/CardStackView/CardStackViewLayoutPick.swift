import UIKit

final class CardStackViewLayoutPick: CardStackViewLayout {
    var stackView: CardStackView!
    var layoutContext: CardStackViewLayoutContext!
    private let selectedCard: UIView
    private let panGestureRecognizer: UIPanGestureRecognizer

    init(selectedCard: UIView, panGestureRecognizer: UIPanGestureRecognizer) {
        self.selectedCard = selectedCard
        self.panGestureRecognizer = panGestureRecognizer
    }

    func willBecomeActive() {}

    func didBecomeInactive() {}

    func willBecomeInactive() {}

    func didBecomeActive() {
        stackView.delegate?.stackView(stackView, startPickingCard: selectedCard)
    }

    func layout(cards: [UIView]) {
        cards.enumerated().forEach { (i: Int, card: UIView) in
            var frame = CGRect(
                x: layoutContext.edgeInsets.left,
                y: stackView.bounds.size.height - layoutContext.edgeInsets.bottom - layoutContext.lookAhead * CGFloat(i + 1),
                width: layoutContext.cardSize.width,
                height: layoutContext.cardSize.height
            )
            if card == selectedCard {
                frame.origin.y += panGestureRecognizer.translation(in: stackView).y
            }
            card.frame = frame
        }
    }

    func didTap(cardView _: UIView, recognizer _: UITapGestureRecognizer) {}

    func didPan(cardView: UIView, recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .recognized else {
            stackView.setCurrentLayout(self, animated: false, completionBlock: nil)
            return
        }

        let newLayout: CardStackViewLayout
        if panGestureRecognizer.translation(in: stackView).y < -100.0 {
            newLayout = CardStackViewLayoutLayoutExpanded(selectedCard: cardView)
        } else {
            newLayout = CardStackViewLayoutLayoutCollapsed()
        }
        stackView.setCurrentLayout(newLayout, animated: true, completionBlock: nil)
    }
}
