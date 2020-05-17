import UIKit

final class CardStackViewLayoutLayoutExpanded : CardStackViewLayout {
    var stackView: CardStackView!
    var layoutContext: CardStackViewLayoutContext!
    private let selectedCard: UIView
    private var drag = CGFloat(0)
    
    init(selectedCard: UIView) {
        self.selectedCard = selectedCard
    }
    
    private func changeSelectedCardFocus(_ focused: Bool) {
        stackView.delegate?.stackView(stackView, didExpandCard: selectedCard)
    }
        
    func willBecomeActive() {
        stackView.delegate?.stackView(stackView, willExpandCard: selectedCard)
    }
    
    func didBecomeInactive() {
        stackView.delegate?.stackViewDidCollapse(stackView)
        changeSelectedCardFocus(false)
    }
    
    func didBecomeActive() {
        changeSelectedCardFocus(true)
    }
    
    private func dump(_ x: CGFloat) -> CGFloat {
        if x == 0 {
            return 0
        } else if x > 0 {
            return -(1.0 / (x + 1.0) - 1.0)
        } else {
            return -(1.0 / (x - 1.0) + 1.0)
        }
    }
    
    func layout(cards: [UIView]) {
        cards.enumerated().forEach { (i: Int, card: UIView) in
            let y: CGFloat
            if card == selectedCard {
                y = layoutContext.edgeInsets.top + dump(drag / 100.0) * 100.0
            } else {
                y = stackView.bounds.height - layoutContext.lookAhead * CGFloat(i + 1) * 0.2
            }
            card.frame = CGRect(
                x: layoutContext.edgeInsets.left,
                y: y,
                width: layoutContext.cardSize.width,
                height: layoutContext.cardSize.height
            )
        }
    }
    
    func didTap(cardView: UIView, recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else {
            return
        }
        let newLayout = CardStackViewLayoutLayoutCollapsed()
        stackView.setCurrentLayout(newLayout, animated: true, completionBlock: nil)
    }
    
    func didPan(cardView: UIView, recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            drag = recognizer.translation(in: stackView).y
            stackView.setCurrentLayout(self, animated: false, completionBlock: nil)
        case .recognized:
            if (drag > 100) {
                let newLayout = CardStackViewLayoutLayoutCollapsed()
                stackView.setCurrentLayout(newLayout, animated: true, completionBlock: nil)
            } else {
                drag = 0
                stackView.setCurrentLayout(self, animated: true, completionBlock: nil)
            }
        default:
            break
        }
    }
}
