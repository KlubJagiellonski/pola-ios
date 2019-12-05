import UIKit

protocol CardStackViewLayout: class {
    var stackView: CardStackView! { get set }
    var layoutContext: CardStackViewLayoutContext! { get set }
    
    func willBecomeActive()
    func didBecomeInactive()
    func didBecomeActive()
    func layout(cards: [UIView])
    func didTap(cardView: UIView, recognizer: UITapGestureRecognizer)
    func didPan(cardView: UIView, recognizer: UIPanGestureRecognizer)
}
