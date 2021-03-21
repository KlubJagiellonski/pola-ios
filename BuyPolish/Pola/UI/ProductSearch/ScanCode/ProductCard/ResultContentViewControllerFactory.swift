import UIKit

final class ResultContentViewControllerFactory {
    static func create(scanResult: ScanResult) -> UIViewController {
        if scanResult.companies?.count == 2 {
            return OwnBrandContentViewController(result: scanResult)
        }

        if let altText = scanResult.altText,
            !altText.isEmpty {
            return AltResultContentViewController(result: scanResult)
        }
        return CompanyContentViewController(result: scanResult)
    }
}
