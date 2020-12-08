import Foundation

final class AnalyticsHelper {
    let provider: AnalyticsProvider

    init(provider: AnalyticsProvider) {
        self.provider = provider
    }

    func barcodeScanned(_ barcode: String, type: AnalyticsBarcodeSource) {
        logEvent(name: .scanCode,
                 parameters:
                 AnalyticsScanCodeParameters(code: barcode,
                                             source: type.rawValue))
    }

    func received(productResult: ScanResult) {
        logEvent(name: .companyReceived,
                 parameters:
                 AnalyticsProductResultParameters(code: productResult.code,
                                                  company: productResult.name,
                                                  product_id: "\(productResult.productId)"))
    }

    func opensCard(productResult: ScanResult) {
        logEvent(name: .cardOpened,
                 parameters:
                 AnalyticsProductResultParameters(code: productResult.code,
                                                  company: productResult.name,
                                                  product_id: "\(productResult.productId)"))
    }

    func reportShown(barcode: String) {
        logEvent(name: .reportStarted,
                 parameters: reportParameters(barcode: barcode))
    }

    func reportSent(barcode: String?) {
        logEvent(name: .reportFinished,
                 parameters: reportParameters(barcode: barcode))
    }

    func donateOpened(barcode: String?) {
        logEvent(name: .donateOpened,
                 parameters: reportParameters(barcode: barcode))
    }

    func aboutOpened(windowName: AnalyticsAboutRow) {
        logEvent(name: .menuItemOpened,
                 parameters:
                 AnalyticsAboutParameters(item: windowName.rawValue))
    }

    func polasFriendsOpened() {
        logEvent(name: .polasFriends)
    }

    func aboutPolaOpened() {
        logEvent(name: .aboutPola)
    }

    private func reportParameters(barcode: String?) -> AnalyticsReportParameters {
        return AnalyticsReportParameters(code: barcode ?? "No Code")
    }

    private func logEvent(name: AnalyticsEventName, parameters: AnalyticsParameters? = nil) {
        let dictionary = parameters?.dictionary as? [String: String]
        provider.logEvent(name: name.rawValue, parameters: dictionary)
    }
}
