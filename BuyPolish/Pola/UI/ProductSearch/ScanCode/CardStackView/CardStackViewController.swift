import UIKit

final class CardStackViewController: UIViewController {
    private(set) var cards = [UIViewController]()
    var castedView: CardStackView! {
        view as? CardStackView
    }

    var cardCount: Int {
        cards.count
    }

    weak var delegate: CardStackViewControllerDelegate?

    override func loadView() {
        view = CardStackView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        castedView.delegate = self
    }

    func add(card: UIViewController) -> Bool {
        cards.append(card)
        addChild(card)
        let result = castedView.addCard(card.view)
        card.didMove(toParent: self)
        return result
    }

    func remove(card: UIViewController) {
        guard !cards.contains(card) else {
            return
        }
        card.willMove(toParent: nil)
        castedView.removeCard(card.view)
        card.removeFromParent()
    }
}

extension CardStackViewController: CardStackViewDelegate {
    private func viewControllerForView(_ card: UIView) -> UIViewController {
        cards.first { vc -> Bool in
            vc.view === card
        }!
    }

    func stackView(_: CardStackView, willAddCard card: UIView, titleHeight: CGFloat) {
        let vc = viewControllerForView(card)
        if var vc = vc as? CardStackViewControllerCard {
            vc.titleHeight = titleHeight
        }
        delegate?.stackViewController(self, willAddCard: vc)
    }

    func stackView(_: CardStackView, willExpandCard card: UIView) {
        delegate?.stackViewController(self, willExpandCard: viewControllerForView(card))
    }

    func stackView(_: CardStackView, didExpandCard card: UIView) {
        let vc = viewControllerForView(card)
        if let vc = vc as? CardStackViewControllerCard {
            vc.didBecameExpandedCard()
        }
    }

    func stackViewDidCollapse(_: CardStackView) {
        delegate?.stackViewControllerDidCollapse(self)
    }
}
