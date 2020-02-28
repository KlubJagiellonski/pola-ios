import UIKit

@objc
protocol CardStackViewControllerDelegate: class {
    func stackViewController(_ stackViewController: CardStackViewController, willAddCard card: UIViewController)
    func stackViewController(_ stackViewController: CardStackViewController, willExpandCard card: UIViewController)
    func stackViewControllerDidCollapse(_ stackViewController: CardStackViewController)
}
