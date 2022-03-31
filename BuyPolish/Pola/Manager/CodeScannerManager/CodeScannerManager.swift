import UIKit

protocol CodeScannerManager: AnyObject {
    var previewLayer: CALayer { get }
    var delegate: ScanningDelegate? { get set }

    func start()
    func stop()
}
