import Foundation
import Firebase
import Crashlytics

@objc(BPAnalyticsHelper)
final class AnalyticsHelper: NSObject {

    @objc
    class func configure() {
        if (firebaseAvailable) {
            FirebaseApp.configure()
        }
        Crashlytics.sharedInstance().setUserIdentifier(UIDevice.current.deviceId)
    }

    @objc
    class func barcodeScanned(_ barcode: String, type: String) {
        logEvent(name: .scan_code,
                 parameters:
            AnalyticsScanCodeParameters(code: barcode,
                                        device_id: UIDevice.current.deviceId,
                                        source: type))
    }

    @objc(receivedProductResult:)
    class func received(productResult: BPScanResult) {
        logEvent(name: .company_received,
                 parameters:
            AnalyticsProductResultParameters(code: productResult.code,
                                               company: productResult.code,
                                               device_id: UIDevice.current.deviceId,
                                               product_id: productResult.productId?.stringValue,
                                               ai_requested: productResult.askForPics ? 1 : 0))
    }

    @objc(opensCard:)
    class func opensCard(productResult: BPScanResult) {
        logEvent(name: .card_opened,
                 parameters:
            AnalyticsProductResultParameters(code: productResult.code,
                                             company: productResult.code,
                                             device_id: UIDevice.current.deviceId,
                                             product_id: productResult.productId?.stringValue,
                                             ai_requested: nil))
    }

    @objc(reportShown:)
    class func reportShown(barcode: String) {
        logEvent(name: .report_started,
                 parameters: reportParameters(barcode: barcode))
    }

    @objc(reportSent:)
    class func reportSent(barcode: String?) {
        logEvent(name: .report_finished,
                 parameters: reportParameters(barcode: barcode))
    }

    @objc(aboutOpened:)
    class func aboutOpened(windowName: String) {
        logEvent(name: .menu_item_opened,
                 parameters:
            AnalyticsAboutParameters(item: windowName,
                                      device_id: UIDevice.current.deviceId))
    }

    @objc(teachReportShow:)
    class func teachReportShow(barcode: String) {
        logEvent(name: .aipics_started,
                 parameters: reportParameters(barcode: barcode))
    }

    @objc(teachReportSent:)
    class func teachReportSent(barcode: String) {
        logEvent(name: .aipics_finished,
                 parameters: reportParameters(barcode: barcode))
    }

    private class func reportParameters(barcode: String?) -> AnalyticsReportParameters {
        return AnalyticsReportParameters(code: barcode ?? "No Code",
                                         device_id: UIDevice.current.deviceId)
    }

    private class func logEvent(name: AnalyticsEventName, parameters: AnalyticsParameters) {
        let nameString = name.rawValue
        let dictionary = parameters.dictionary
        if (firebaseAvailable) {
            Analytics.logEvent(nameString, parameters: dictionary)
        }
        CLSLogv("%@: %@", getVaList([nameString, dictionary ?? [:]]))
    }

    private class var firebaseAvailable: Bool {
        return Bundle(for: self).path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }
}
