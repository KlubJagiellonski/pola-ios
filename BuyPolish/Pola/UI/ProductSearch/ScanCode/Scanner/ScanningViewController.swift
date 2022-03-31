import Swinject
import UIKit

protocol ScanningDelegate: AnyObject {
    func didScan(barcode: String, sourceType: AnalyticsBarcodeSource)
}

protocol ScanningViewController: UIViewController {
    var scannerDelegate: ScanningDelegate? { get set }
}

final class ScanningViewControllerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ScanningViewController.self) { _ in
            ScanditScannerViewController()
//            ScannerCodeViewController(codeScannerManager: CameraSessionCodeScannerManager())
        }
    }
}
