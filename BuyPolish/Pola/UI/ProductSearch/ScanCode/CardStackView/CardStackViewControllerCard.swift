import UIKit

protocol CardStackViewControllerCard {
    var titleHeight: CGFloat { get set }
    func willBecameExpandedCard()
    func didBecameExpandedCard()
    func willBecameCollapsedCard()
}
