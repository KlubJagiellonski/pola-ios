import UIKit

protocol ScanningDelegate: AnyObject {
    func didScan(barcode: String, sourceType: AnalyticsBarcodeSource)
}

protocol ScanningViewController: UIViewController {
    var scannerDelegate: ScanningDelegate? { get set }
}
