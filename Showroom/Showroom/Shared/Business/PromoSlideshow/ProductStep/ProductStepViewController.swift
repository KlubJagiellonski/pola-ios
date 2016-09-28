import Foundation
import UIKit

final class ProductStepViewController: UIViewController, PromoPageInterface {
    weak var delegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, productId: ObjectId) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
