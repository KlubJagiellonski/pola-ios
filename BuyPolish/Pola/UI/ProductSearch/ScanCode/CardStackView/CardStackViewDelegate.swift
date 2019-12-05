import UIKit

@objc
protocol CardStackViewDelegate: class {
    func stackView(_ stackView: CardStackView, willAddCard card: UIView)
    func stackView(_ stackView: CardStackView, didRemoveCard card: UIView)
    func stackView(_ stackView: CardStackView, willExpandWithCard card: UIView)
    func stackViewDidCollapse(_ stackView: CardStackView)
    func stackView(_ stackView: CardStackView, didTapCard card: UIView) -> Bool
}
