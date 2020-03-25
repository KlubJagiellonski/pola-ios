import UIKit

protocol CodeScannerManagerDelegate: class {
    func didScan(barcode: String)
}

protocol CodeScannerManager: class {
    var previewLayer: CALayer { get }
    var delegate: CodeScannerManagerDelegate? { get set }
    
    func start()
    func stop()
}
