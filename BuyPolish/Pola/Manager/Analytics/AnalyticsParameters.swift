import Foundation

protocol AnalyticsParameters: Encodable {}

struct AnalyticsScanCodeParameters: AnalyticsParameters {
    let code: String
    let source: String
}

struct AnalyticsProductResultParameters: AnalyticsParameters {
    let code: String?
    let company: String?
    let product_id: String?
}

struct AnalyticsReportParameters: AnalyticsParameters {
    let code: String
}

struct AnalyticsAboutParameters: AnalyticsParameters {
    let item: String
}
