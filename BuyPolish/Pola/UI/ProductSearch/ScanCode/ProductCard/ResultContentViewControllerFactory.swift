import UIKit

final class ResultContentViewControllerFactory {
    static func create(scanResult: ScanResult) -> UIViewController {
        if scanResult.code == "20820299" {
            return OwnBrandContentViewController()
        }

        if let altText = scanResult.altText,
            !altText.isEmpty {
            return AltResultContentViewController(result: scanResult)
        }
        return CompanyContentViewController(result: scanResult)
    }
}
