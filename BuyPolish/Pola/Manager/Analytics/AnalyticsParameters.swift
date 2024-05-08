import Foundation

protocol AnalyticsParameters: Encodable {}

struct AnalyticsScanCodeParameters: AnalyticsParameters {
    let code: String
    let source: AnalyticsBarcodeSource
}

struct AnalyticsProductResultParameters: AnalyticsParameters {
    let code: String?
    let company: String?
    let product_id: String?
}

struct AnalyticsReadMoreParameters: AnalyticsParameters {
    let code: String?
    let company: String?
    let product_id: String?
    let url: String
}

struct AnalyticsReportParameters: AnalyticsParameters {
    let code: String
}

struct AnalyticsAboutParameters: AnalyticsParameters {
    let item: String
}

struct AnalyticsMainTabParameters: AnalyticsParameters {
    let tab: AnalyticsMainTab
}
