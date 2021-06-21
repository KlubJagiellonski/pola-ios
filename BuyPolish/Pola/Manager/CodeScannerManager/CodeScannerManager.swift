import UIKit

protocol CodeScannerManagerDelegate: AnyObject {
    func didScan(barcode: String, sourceType: AnalyticsBarcodeSource)
}

protocol CodeScannerManager: AnyObject {
    var previewLayer: CALayer { get }
    var delegate: CodeScannerManagerDelegate? { get set }

    func start()
    func stop()
}
