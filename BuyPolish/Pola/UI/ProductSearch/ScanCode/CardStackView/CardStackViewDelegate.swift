import UIKit

protocol CardStackViewDelegate: class {
    func stackView(_ stackView: CardStackView, willAddCard card: UIView, titleHeight: CGFloat)
    func stackView(_ stackView: CardStackView, didRemoveCard card: UIView)
    func stackView(_ stackView: CardStackView, willExpandCard card: UIView)
    func stackView(_ stackView: CardStackView, didExpandCard card: UIView)
    func stackViewDidCollapse(_ stackView: CardStackView)
}
