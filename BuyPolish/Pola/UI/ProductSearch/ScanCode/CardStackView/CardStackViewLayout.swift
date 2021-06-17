import UIKit

protocol CardStackViewLayout: AnyObject {
    var stackView: CardStackView! { get set }
    var layoutContext: CardStackViewLayoutContext! { get set }

    func willBecomeActive()
    func didBecomeInactive()
    func willBecomeInactive()
    func didBecomeActive()
    func layout(cards: [UIView])
    func didTap(cardView: UIView, recognizer: UITapGestureRecognizer)
    func didPan(cardView: UIView, recognizer: UIPanGestureRecognizer)
}
