import UIKit

protocol CardStackViewControllerDelegate: AnyObject {
    func stackViewController(_ stackViewController: CardStackViewController, willAddCard card: UIViewController)
    func stackViewController(_ stackViewController: CardStackViewController, willExpandCard card: UIViewController)
    func stackViewController(_ stackViewController: CardStackViewController, didExpandCard card: UIViewController)
    func stackViewController(_ stackViewController: CardStackViewController, startPickingCard card: UIViewController)
    func stackViewControllerDidCollapse(_ stackViewController: CardStackViewController)
}
