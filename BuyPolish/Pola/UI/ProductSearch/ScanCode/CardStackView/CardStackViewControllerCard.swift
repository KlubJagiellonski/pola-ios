import UIKit

protocol CardStackViewControllerCard {
    var titleHeight: CGFloat { get set }
    func didBecameExpandedCard()
}
