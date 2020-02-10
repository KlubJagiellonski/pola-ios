import UIKit

@objc
protocol CodeScannerManagerDelegate: class {
    @objc(didScanBarcode:)
    func didScan(barcode: String)
}

@objc
protocol CodeScannerManager: class {
    var previewLayer: CALayer { get }
    var delegate: CodeScannerManagerDelegate? { get set }
    
    func start()
    func stop()
}
