import UIKit

final class CardStackView: UIView {
    weak var delegate: CardStackViewDelegate?
    private var cards = [UIView]()
    private var layout: CardStackViewLayout
    private var layoutContext =
        CardStackViewLayoutContext(edgeInsets: .zero, lookAhead: 50.0, cardSize: .zero, cardCountLimit: 3)

    override init(frame: CGRect) {
        layout = CardStackViewLayoutLayoutCollapsed()
        super.init(frame: frame)
        setCurrentLayout(CardStackViewLayoutLayoutCollapsed(), animated: false, completionBlock: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCard(_ card: UIView) -> Bool {
        guard !cards.contains(card) else {
            return false
        }

        delegate?.stackView(self, willAddCard: card, titleHeight: layoutContext.lookAhead)

        cards.append(card)
        addSubview(card)
        sendSubviewToBack(card)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCard(recognizer:)))
        card.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanCard(recognizer:)))
        card.addGestureRecognizer(panGestureRecognizer)

        // Step 1: place the card off screen
        setCurrentLayout(CardStackViewLayoutLayoutCollapsed(offScreenCard: card),
                         animated: false,
                         completionBlock: nil)

        // Step 2: animate on screen (optionally move over limit card off screen and remove after it's done)
        let toBeRemovedCard = cards.count > layoutContext.cardCountLimit ? cards.first : nil
        setCurrentLayout(CardStackViewLayoutLayoutCollapsed(offScreenCard: toBeRemovedCard),
                         animated: true) { [weak self, weak toBeRemovedCard] in
            guard let self = self,
                let toBeRemovedCard = toBeRemovedCard else {
                return
            }
            self.cardRemovedFromUI(toBeRemovedCard)
        }

        return true
    }

    func removeCard(_ card: UIView) {
        guard cards.contains(card) else {
            return
        }

        setCurrentLayout(CardStackViewLayoutLayoutCollapsed(offScreenCard: card),
                         animated: true) { [weak self, weak card] in
            guard let self = self,
                let card = card else {
                return
            }
            self.cardRemovedFromUI(card)
        }
    }

    private func cardRemovedFromUI(_ removedCard: UIView) {
        guard let index = cards.firstIndex(of: removedCard) else {
            return
        }
        cards.remove(at: index)
        removedCard.removeFromSuperview()
    }

    func setCurrentLayout(_ currentLayout: CardStackViewLayout, animated: Bool, completionBlock: (() -> Void)?) {
        let oldLayout: CardStackViewLayout?
        if !(currentLayout === layout) {
            oldLayout = layout
            layout = currentLayout
            layout.stackView = self
            layout.layoutContext = layoutContext
            layout.willBecomeActive()
        } else {
            oldLayout = nil
        }

        if animated {
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: { [weak self] in
                               guard let self = self else {
                                   return
                               }
                               self.forceLayout()
            }) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.layoutChanged(oldLayout: oldLayout, completionBlock: completionBlock)
            }

        } else {
            forceLayout()
            layoutChanged(oldLayout: oldLayout, completionBlock: completionBlock)
        }
    }

    private func forceLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func layoutChanged(oldLayout: CardStackViewLayout?, completionBlock: (() -> Void)?) {
        if let oldLayout = oldLayout {
            oldLayout.didBecomeInactive()
            layout.didBecomeActive()
        }
        if let completionBlock = completionBlock {
            completionBlock()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cardMargin = CGFloat(3)
        let edgeInsets = UIEdgeInsets(
            top: topSafeAreaInset + cardMargin,
            left: cardMargin,
            bottom: .zero,
            right: cardMargin
        )
        layoutContext.edgeInsets = edgeInsets
        layoutContext.cardSize = CGSize(
            width: bounds.width - edgeInsets.left - edgeInsets.right,
            height: bounds.height - edgeInsets.top - edgeInsets.bottom - layoutContext.lookAhead
        )
        layout.layout(cards: cards)
    }

    @objc
    private func didTapCard(recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        layout.didTap(cardView: view, recognizer: recognizer)
    }

    @objc
    private func didPanCard(recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        layout.didPan(cardView: view, recognizer: recognizer)
    }

    var cardCount: UInt {
        return UInt(cards.count)
    }

    var cardsHeight: CGFloat {
        let visibleCardsCount = min(cardCount, layoutContext.cardCountLimit)
        return CGFloat(visibleCardsCount) * layoutContext.lookAhead
    }

    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        return subviews.contains { (view) -> Bool in
            view.frame.contains(point)
        }
    }
}
