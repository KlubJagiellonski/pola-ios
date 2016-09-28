import Foundation
import UIKit

final class ImageStepViewController: UIViewController, PromoPageInterface {
    weak var delegate: PromoPageDelegate?
    
    init(with resolver: DiResolver, link: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}