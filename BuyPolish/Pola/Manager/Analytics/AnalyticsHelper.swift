import Crashlytics
import Firebase
import Foundation

final class AnalyticsHelper {
    class func configure() {
        if firebaseAvailable {
            FirebaseApp.configure()
        }
        Crashlytics.sharedInstance().setUserIdentifier(UIDevice.current.deviceId)
    }

    class func barcodeScanned(_ barcode: String, type: AnalyticsBarcodeSource) {
        logEvent(name: .scanCode,
                 parameters:
                 AnalyticsScanCodeParameters(code: barcode,
                                             device_id: UIDevice.current.deviceId,
                                             source: type.rawValue))
    }

    class func received(productResult: ScanResult) {
        logEvent(name: .companyReceived,
                 parameters:
                 AnalyticsProductResultParameters(code: productResult.code,
                                                  company: productResult.code,
                                                  device_id: UIDevice.current.deviceId,
                                                  product_id: "\(productResult.productId)"))
    }

    class func opensCard(productResult: ScanResult) {
        logEvent(name: .cardOpened,
                 parameters:
                 AnalyticsProductResultParameters(code: productResult.code,
                                                  company: productResult.code,
                                                  device_id: UIDevice.current.deviceId,
                                                  product_id: "\(productResult.productId)"))
    }

    class func reportShown(barcode: String) {
        logEvent(name: .reportStarted,
                 parameters: reportParameters(barcode: barcode))
    }

    class func reportSent(barcode: String?) {
        logEvent(name: .reportFinished,
                 parameters: reportParameters(barcode: barcode))
    }

    class func donateOpened(barcode: String?) {
        logEvent(name: .donateOpened,
                 parameters: reportParameters(barcode: barcode))
    }

    class func aboutOpened(windowName: AnalitycsAboutRow) {
        logEvent(name: .menuItemOpened,
                 parameters:
                 AnalyticsAboutParameters(item: windowName.rawValue,
                                          device_id: UIDevice.current.deviceId))
    }

    class func polasFriendsOpened() {
        logEvent(name: .polasFriends,
                 parameters: AnalitycsPolasFriendsParameters(device_id: UIDevice.current.deviceId))
    }

    private class func reportParameters(barcode: String?) -> AnalyticsReportParameters {
        return AnalyticsReportParameters(code: barcode ?? "No Code",
                                         device_id: UIDevice.current.deviceId)
    }

    private class func logEvent(name: AnalyticsEventName, parameters: AnalyticsParameters) {
        let nameString = name.rawValue
        let dictionary = parameters.dictionary
        if firebaseAvailable {
            Analytics.logEvent(nameString, parameters: dictionary)
        }
        CLSLogv("%@: %@", getVaList([nameString, dictionary ?? [:]]))
    }

    private class var firebaseAvailable: Bool {
        return Bundle(for: self).path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }
}
