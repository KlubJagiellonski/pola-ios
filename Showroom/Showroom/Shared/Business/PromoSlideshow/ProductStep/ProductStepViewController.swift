import Foundation
import UIKit

final class ProductStepViewController: ProductPageViewController, PromoPageInterface {
    weak var pageDelegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, productId: ObjectId) {
        super.init(resolver: resolver, productId: productId, product: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
