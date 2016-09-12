import Foundation
import UIKit

protocol TouchHandlingDelegate {
    func shouldConsumeTouch(touch: UITouch) -> Bool
}