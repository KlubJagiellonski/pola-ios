import UIKit

protocol CardStackViewDelegate: AnyObject {
    func stackView(_ stackView: CardStackView, willAddCard card: UIView, titleHeight: CGFloat)
    func stackView(_ stackView: CardStackView, willExpandCard card: UIView)
    func stackView(_ stackView: CardStackView, didExpandCard card: UIView)
    func stackView(_ stackView: CardStackView, willCollapseCard card: UIView)
    func stackView(_ stackView: CardStackView, didCollapseCard card: UIView)
    func stackView(_ stackView: CardStackView, startPickingCard card: UIView)
}
