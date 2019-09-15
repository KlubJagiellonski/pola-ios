import UIKit

class ResultContentViewControllerFactory {
    
    static func create(scanResult: BPScanResult) -> UIViewController {
        if let altText = scanResult.altText,
            !altText.isEmpty {
            return CompanyAltContentViewController(result: scanResult)
        }
        return CompanyContentDefaultViewController(result: scanResult)
    }
}
